/*
 * Name:    PyHouse-ansible/roles/install-node-red/files/localSettings.js
 * Author:  D. Brian Kimmel
 * Created: 2018-03-11
 * Updated: 2018-05-11
 *
 */

module.exports = {
    "house_name"       : "{{pyh_house_name}}",
    "node_name"        : "{{hostname_hostname}}",
    "public_ipv4"      : "1.2.3.4",
    "connection_lost"  : "Unknown",
    "front_drip_relay" : "Unknown"
}
// ### END DBK
