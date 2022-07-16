# cbus2mqtt
A cmqttd add on for Home Assistant
cbus2mqtt is a Home Assistant add on runs the cmqttd process to communicate with CBUS PCI or CNI devices.

# Warning
This add-on is currently in beta awaiting real world testing.  It is at the end of the day simply running the cmqttd Docker container with some minor modifictions. Testing has shown it passes through the home assistant configuration options correctly and the local build version was tested on a CBUS CNI.  (I dont have CBUS so my testing is limited)

## Installation
To install Home Assistant you need to add a repository to your Home Assistant Add-on Store.
1.	From the main menu select System, then Add-ons
2.	In the lower right corner click on the blue button titled ADD-ON-STORE
3.	In the top right click on the 3 vertical dots (be careful to click on the home assistant dots and not your browser menu dots)
4.	Select Repositories
5.	Paste the following URL and click Add  https://github.com/MtSamsonite/ha-cbus2mqtt
6.	You can now select the cbus2mqtt Add on from the available selection.

## About cbus2mqttd
This add on has only been possible due to the development of the cmqttd process and docker containers provided by others.  For information about cmqttd, how it works, relevant licensing and further details on how the various parameters are used, please refer to the authors documentation which can be found at https://cbus.readthedocs.io/en/latest/cmqttd.html.

This add-on also includes a pull request (by others) to the original cmqttd implementation For details on the pull request which has been included refer to https://github.com/micolous/cbus/pull/31

## Requirements
You need to have a MQTT server operating to use this add on.  If you do not currently operate a MQTT server it is recommended you add the Mosquitto MQTT Server official add-on for home assistant. You can add this via the home assistant interface by navigating to the Add-on Store.

You will also need to supply a username and password to access the MQTT Broker.  If you are using the Home Assistant Mosquitto MQTT official add-on you can simply create a user in Home Assistant. The Mosquitto MQTT server add on can authenticate against Home Assistant.

You will also need to install the MQTT integration for Home Assistant and ensure that the MQTT discovery option is enabled.  This will allow Home Assistant to discover the lighting groups on your CBUS lighting circuit and import them as lights and sensors.

Home Assistant add on repository : https://github.com/MtSamsonite/ha-cbus2mqtt
## Basic Configuration
For detailed instructions on how the various parameters influence the behaviour of cmqttd please refer to the documentation provided by the author of cmqttd - https://cbus.readthedocs.io/en/latest/cmqttd.html.

Most users should only need to set the options below:
### mqtt_broker_address
If you are using the Home Assistant Mosquitto MQTT official add on you can leave this field set with the default value ‘core-mosquitto’.   If you run a separate MQTT server you will you need to enter its IP address in this field.

mqtt_broker_address is the equivalent of the cmqttd parameter --broker-address
### mqtt_user
This add on only supports authenticated access to a MQTT server.  If you are using the Home Assistant Mosquitto MQTT official add on you can simply add a user to Home Assistant, otherwise create a valid username and password cmqttd can use to authenticate to your MQTT server.

Enter the username in this field.

mqtt_user and mqtt_password options are passed to the cbus2mqttd add-on which creates a file cmqttd uses to authenticate access to MQTT.  This file is created when the add-on starts and is located inside the add on at /etc/cmqttd/auth.
### mqtt_password
In this field enter the password to authenticate your access to the MQTT server.   This is the password for the user provided in the field above.
### tcp_or_serial
Select the type of interface used to connect to your CBUS system.  The cmqttd process supports connections via either a serial interface to a CBUS PCI or IP connections to ethernet to a CBUS CNI device.

tcp_or_serial is used to determine which of the following two cmqttd parameters are employed: --serial or –tcp.
### cbus_connection_string
In here you need to enter the connection string that will be passed to cmqttd for your serial or tcp connection. (selected in the field above).
Serial interfaces

A serial connection requires a valid path to your serial device and would be something like one of the following
/dev/ttyS0
/dev/ttyS1
/dev/serial/by-id/usb-XXXX_XXXX-XXXX

For an IP connection enter the IP address of your CNI or CBUS IP gateway followed by a colon (:) and then the port number.  By default the CNI uses port number 10001.  So for example a valid entry in here would be something like 192.168.1.131:10001

The Connection string is used as the value for cmqttd parameters --serial or --tcp dependant on the option selected for either serial or IP connection.

## Advanced Configuration
To view advanced configuration options choose the “Show unused optional configuration options”

The options below are considered for more advanced users only and as such it is expected they would read the documentation provided by the cmqttd author at https://cbus.readthedocs.io/en/latest/cmqttd.html.

The cbus2mqtt add on has read only access to Home Assistants /config directory.   To use many of the options below requires that you provide files accessible by the cbus2mqtt add on.

Advanced users wishing to utilise these features are recommended to use SAMBA or ssh or other add-ons that provide file access HA to create a directory below /config such as /config/cbus and upload any required files to this location.
## use_tls_for_mqtt
This option is off  by default.

To use TLS requires you create and upload certificates  and provide CA files accessible by the cbus2mqtt in the options below.

The cbus2mqtt add-on has read only access to your /config directory.  Please place required files below this directory. Eg: /config/cbus.

use_tls_for_mqtt if disabled will include the cmqttd parameter --broker-disable-tls
## mqtt_broker_port
By default the cmqttd process will use port 1833 when TLS is disabled and port 8883 when TLS is enabled.  This can be overwritten by providing a port value in this field.

mqtt_broker_port is the equivalent of cmqttd parameter --broker-port
## broker_ca
Example: /config/cbus/certificates

broker_ca is the equivalent of cmqttd parameter --broker-ca
## broker_client_cert
Example: /config/cbus/certificates

broker_client_cert is the equivalent of cmqttd parameter --broker-client-cert
## broker_client_key
Example: /config/cbus/client.key

broker_client_key is the equivalent of cmqttd parameter --broker-client-key
## project_file
Example: /config/cbus/project.cbz

project_file is the equivalent of cmqttd parameter --project-file
## timesync
Example: 300

timesync is the equivalent of cmqttd parameter --timesync
## no_clock
If enabled the cmqttd will not respond to time request from CBUS.

no_clock is the equivalent of cmqttd parameter --no-clock
## log_verbosity
log_verbosity is the equivalent of cmqttd parameter --verbosity

## Troubleshooting
1.	Check the parameters are passing through correctly.  This can be seen in the logs, just prior to starting cmqttd, the startup script outputs a statement like: 
"Running cmqttd with flags: --broker-address core-mosquitto --timesync 300 --tcp 192.168.1.131:10001 --broker-disable-tls --broker-auth /etc/cmqttd/auth".   You can check if this is correct by referencing the documentation at: https://cbus.readthedocs.io/en/latest/cmqttd.html
2.	If you have filled in an option and it is not being displayed as a parameter on the line above as you expect, then check the log for errors with the value you provided.
3.	Check the logs for any further errors.
4.	If you believe the issue is related to the way the cbus2mqtt add-on calls cmqttd then please raise an issue with this cbus2qmtt add-on.

