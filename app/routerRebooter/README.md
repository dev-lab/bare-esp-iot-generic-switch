# Router Rebooter
The application allows to reboot an internet router when the Internet disappears.

# How it works
The device must be configured to use WiFi access point with the Internet coming through the router to be rebooted. When device's Wi-Fi connection is set up, the router's power must be connected via NodeMCU device's relay (such as Sonoff Plug). The app will keep trying to resolve www.google.com server name, and if it can't do it for a few minutes, it turn off the relay for a while and then turn it on again. This will reboot the internet router and repair the Internet connection, if the problem was with the router and not with the external infrastructure.

# Usage
Possibility to shoot yourself in the foot is not excluded, so don't use Web UI of the router rebooter (e.g. through VPN or SSH tunnel) when you are at a distance to the router. You may accidentally turn off the relay, which will result in loss of the Internet at remote site, until you physically turn off/on the NodeMCU device. To prevent this, set both the admin and the user passwords of [**Bare ESP8266 NodeMCU IoT Generic Switch**](https://github.com/dev-lab/bare-esp-iot-generic-switch) to something that is difficult to remember and hard to retrieve.