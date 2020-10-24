#! /usr/bin/python3

from urllib.request import Request, urlopen
from urllib.error import URLError
import re

REQUEST_LIST = [
    'http://ipv4bot.whatsmyipaddress.com/',
    'http://ipecho.net/plain',
    'http://observebox.com/ip',
    'http://icanhazip.com',
    'http://ifconfig.me'
    ]


def find_my_public_ip():
    """
    """
    for l_url in REQUEST_LIST:
        l_site = Request(l_url)
        try:
            l_response = urlopen(l_site)
        except URLError as e_err:
            if hasattr(e_err, 'reason'):
                print('We failed to reach a server.')
                print('Reason: ', e_err.reason)
            elif hasattr(e_err, 'code'):
                print('The server couldn\'t fulfill the request.')
                print('Error code: ', e_err.code)
        else:
            l_html = l_response.read()
            l_text = l_html.decode()
            #l_re = re.findall('<td class="w2p_fw">(.*?)</td>',l_text)
            #print(l_text)
            l_myip = re.findall(r"\b\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}\b", l_text)
            if l_myip != []:
                print(f'Found: {l_myip}')
                return l_myip[0]
            print("Skipped {}".format(l_url))
    return None

def update_duckdns(p_ip):
    l_token = 'ddc2fe4f-3d52-4976-a72d-803e0e034f41'
    l_domain = 'cannontrail.duckdns.org'
    l_ip = p_ip
    l_duck_url = f'http://www.duckdns.org/update?domains={l_domain}&token={l_token}&ip={l_ip}'

    print(f'Update DuckDNS with {p_ip}')
    print(l_duck_url)
    try:
        l_response = urlopen(l_duck_url)
    except Exception as e_err:
        print('Err, e_err')
    else:
        l_html = l_response.read()

def update_freedns():
    pass

l_ip = find_my_public_ip()
if l_ip:
    l_ret = update_duckdns(l_ip)

### END DBK
