# Role Name: function_email

Install and configure an email server for a house/domain.

## Requirements

Any pre-requisites that may not be covered by Ansible itself or the role should be mentioned here.
For instance, if the role uses the EC2 module, it may be a good idea to mention in this section that the boto package is required.

Role Variables
--------------

A description of the settable variables for this role should go here, including any variables that are in defaults/main.yml, vars/main.yml, and any variables that can/should be set via parameters to the role. Any variables that are read from other roles and/or the global scope (ie. hostvars, group vars, etc.) should be mentioned here as well.

Dependencies
------------

A list of other roles hosted on Galaxy should go here, plus any details in regards to parameters that may need to be set for other roles, or variables that are used from other roles.

Example Playbook
----------------

Including an example of how to use your role (for instance, with variables passed in as parameters) is always nice for users too:

    - hosts: servers
      roles:
         - { role: username.rolename, x: 42 }

## License

MIT

Author Information
------------------

An optional section for the role authors to include contact information, or a website (HTML is not allowed).




## Step-by-step guide

Start from a fresh Raspberry PI OS Lite installation.

Let’s connect via SSH to our Raspberry and, after login, update our system:

```
sudo apt update
sudo apt upgrade
```

## Installing Postfix

Postfix is the default Mail Transfer Agent (MTA) for Ubuntu (the most known Debian distro).
It is used to route email messages between different computers.

In this first installation process a few setup questions will be prompted to you.
Use default settings, it will be completely configured in next step.
To install it:

```
sudo apt install postfix
```

Now we’ll go to detail configurations.
From terminal:

```
sudo dpkg-reconfigure postfix

```

After first setup notification, insert the following details when asked (replacing <admin_user_name> and server.example.com with your domain name if you have one):

    General type of mail configuration: Internet Site
    System mail name: example.com
    Root and postmaster mail recipient: <admin_user_name>
    Other destinations for mail: server.example.com, example.com, localhost.example.com, localhost, raspberrypi
    Force synchronous updates on mail queue?: No
    Local networks: 127.0.0.0/8
    Mailbox size limit (bytes): 0
    Local address extension character: +
    Internet protocols to use: all 

Now is a good time to decide which mailbox format you want to use.
By default Postifx will use mbox for the mailbox format.
Rather than editing the configuration file directly, you can use the postconf command to configure all postfix parameters.
The configuration parameters will be stored in /etc/postfix/main.cf file.
Later if you wish to re-configure a particular parameter, you can either run the command or change it manually in the file.

To configure the mailbox format for Maildir:

```
sudo postconf -e 'home_mailbox = Maildir/'
```

You may need to issue this as well:

```
sudo postconf -e 'mailbox_command ='
```

Note: This will place new mail in /home/username/Maildir so you will need to configure your Mail Delivery Agent to use the same path.

Configure Postfix to do SMTP AUTH using SASL (saslauthd):

```
sudo postconf -e 'smtpd_sasl_local_domain ='
sudo postconf -e 'smtpd_sasl_auth_enable = yes'
sudo postconf -e 'smtpd_sasl_security_options = noanonymous'
sudo postconf -e 'broken_sasl_auth_clients = yes'
sudo postconf -e 'smtpd_recipient_restrictions = permit_sasl_authenticated,permit_mynetworks,reject_unauth_destination'
sudo postconf -e 'inet_interfaces = all'
```

Next edit smtpd.conf:

```
sudo nano /etc/postfix/sasl/smtpd.conf
```

and add the following lines:

```
pwcheck_method: saslauthd
mech_list: plain login
```

Generate certificates to be used for TLS encryption and/or certificate Authentication (launch each command line by line and insert user description when required at your choise):

```
touch smtpd.key
chmod 600 smtpd.key
openssl genrsa 1024 > smtpd.key
openssl req -new -key smtpd.key -x509 -days 3650 -out smtpd.crt
```

Last command will require you some preferences to create your Distinguished Name.
Compile them according your preferences.
Now following command:

```
openssl req -new -x509 -extensions v3_ca -keyout cakey.pem -out cacert.pem -days 3650
```

This command will again ask you for a PEM passphrase (at your choice) and again your Distinguished Name configuration.
Move keys to ssl folder:

```
sudo mv smtpd.key /etc/ssl/private/
sudo mv smtpd.crt /etc/ssl/certs/
sudo mv cakey.pem /etc/ssl/private/
sudo mv cacert.pem /etc/ssl/certs/
```

Configure Postfix to do TLS encryption for both incoming and outgoing mail (remember to modify last command with your hostname):

```
sudo postconf -e 'smtp_tls_security_level = may'
sudo postconf -e 'smtpd_tls_security_level = may'
sudo postconf -e 'smtpd_tls_auth_only = no'
sudo postconf -e 'smtp_tls_note_starttls_offer = yes'
sudo postconf -e 'smtpd_tls_key_file = /etc/ssl/private/smtpd.key'
sudo postconf -e 'smtpd_tls_cert_file = /etc/ssl/certs/smtpd.crt'
sudo postconf -e 'smtpd_tls_CAfile = /etc/ssl/certs/cacert.pem'
sudo postconf -e 'smtpd_tls_loglevel = 1'
sudo postconf -e 'smtpd_tls_received_header = yes'
sudo postconf -e 'smtpd_tls_session_cache_timeout = 3600s'
sudo postconf -e 'tls_random_source = dev:/dev/urandom'
sudo postconf -e 'myhostname = example.com' # remember to change this to yours
```

Restart the postfix daemon:

```
sudo systemctl restart postfix.service
```

### Next steps are to configure Postfix to use SASL for SMTP AUTH.

First you will need to install the libsasl2-2, sasl2-bin and libsasl2-modules from the Main repository [i.e. sudo apt-get install them all].

```
sudo apt install libsasl2-2 sasl2-bin libsasl2-modules
```

We have to change a few things to make it work properly.
Because Postfix runs chrooted in /var/spool/postfix we have to change a couple of paths to live in the false root. (ie. /var/run/saslauthd becomes /var/spool/postfix/var/run/saslauthd):
First, we edit /etc/default/saslauthd in order to activate saslauthd.
Remove # in front of START=yes, add the PWDIR, PARAMS, and PIDFILE lines and edit the OPTIONS line at the end:

```
sudo nano /etc/default/saslauthd
```

so that not commented lines appears like the following:

```
START=yes
PWDIR="/var/spool/postfix/var/run/saslauthd"
PARAMS="-m ${PWDIR}"
PIDFILE="${PWDIR}/saslauthd.pid"
DESC="SASL Authentication Daemon"
NAME="saslauthd"
MECHANISMS="pam"
MECH_OPTIONS=""
THREADS=5
OPTIONS="-c -m /var/spool/postfix/var/run/saslauthd"
```

Next, we update the dpkg “state” of /var/spool/postfix/var/run/saslauthd.
The saslauthd init script uses this setting to create the missing directory with the appropriate permissions and ownership:

```
sudo dpkg-statoverride --force-all --update --add root sasl 755 /var/spool/postfix/var/run/saslauthd
```

This could give a warning that “–update given” and the “/var/spool/postfix/var/run/saslauthd” directory does not exist.
You can ignore this because when you start saslauthd next it will be created. Finally, start saslauthd:

```
sudo systemctl start saslauthd.service
```

## Installing Mail Delivery Agent (Dovecot)

In order to allow you or others to download email from other locations, you need to setup an IMAP or POP3 server.

The installation is extremely simple, just install the following packages:

    dovecot-imapd
    dovecot-pop3d

From terminal:

```
sudo apt install dovecot-imapd dovecot-pop3d
```

Let’s select protocols to be enabled when dovecot is started

```
sudo nano /etc/dovecot/dovecot.conf
```

add at the end of file the following lines:

```
protocols = pop3 pop3s imap imaps
pop3_uidl_format = %08Xu%08Xv
mail_location = maildir:/home/%u/Maildir
```

It is necessary to set mail_location in /etc/dovecot/conf.d/10-mail.conf or comment the line out.
10-mail.conf will override the mail_location in dovecot.conf:

```
sudo nano /etc/dovecot/conf.d/10-mail.conf
```

and change the following line:

```
mail_location = mbox:~/mail:INBOX=/var/mail/%u
```

to the following:

```
mail_location = maildir:~/Maildir
```

It’s a good idea to pre-create the Maildir for future users:

```
sudo maildirmake.dovecot /etc/skel/Maildir
sudo maildirmake.dovecot /etc/skel/Maildir/.Drafts
sudo maildirmake.dovecot /etc/skel/Maildir/.Sent
sudo maildirmake.dovecot /etc/skel/Maildir/.Trash
sudo maildirmake.dovecot /etc/skel/Maildir/.Templates
```

Let’s create a sample user with our pi default user:

```
sudo cp -r /etc/skel/Maildir /home/pi/
sudo chown -R pi:pi /home/pi/Maildir
sudo chmod -R 700 /home/pi/Maildir
```

Start dovecot:

```
sudo systemctl start dovecot.service
```

## Install Webmail (Squirrelmail)

Finally, we’re going to install our webmail application.
We need to start from Apache2 installation:

sudo apt install apache2

Because of some php5 dependencies, we need to enable jessie repository before proceeding in squirrelmail installation:

sudo nano /etc/apt/sources.list

add the following line to the end:

deb http://mirrordirector.raspbian.org/raspbian/ jessie main contrib non-free rpi

update packages list:

sudo apt-get update

Now we can install squirrelmail packages:

sudo apt-get install squirrelmail

Squirrelmail comes with a sample apache configuration file in /etc/squirrelmail/apache.conf. You can copy this file to /etc/apache2/sites-available/squirrelmail with the command:

sudo cp /etc/squirrelmail/apache.conf /etc/apache2/sites-available/squirrelmail.conf

then link it to the sites-enabled directory with the command:

sudo ln -s /etc/apache2/sites-available/squirrelmail.conf /etc/apache2/sites-enabled/squirrelmail.conf

Reload Apache Configuration:

sudo /etc/init.d/apache2 force-reload

Now test logging with a browser to “http://<<yourserver>>/squirrelmail” and using you “pi” user and password.
Enjoy!

PS: as said, be aware of

    to receive mails from internet, you must set a port forwarding rule on your router with port 25 (UDP and TCP) forwarded to your RPI server
    this is a test environment, it is strongly recommended to improve security, antivirus and antispam for production environments
    Raspberry PI Zero W hardware is really poor. It seems to work with low loads, but it has to be tested with increasing traffic and antispam enabled
    mail sent can be classified as “spam” by some mail providers (Gmail, hotmail, etc), so if you test your configuration, check recipients Spam directory

Enjoy!