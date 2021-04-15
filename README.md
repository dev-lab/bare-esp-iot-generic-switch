# Bare ESP8266 NodeMCU IoT Generic Switch 2.0.0
This is the fork of [**ESP8266 NodeMCU IoT Generic Switch 2.0.0**](https://github.com/dev-lab/esp-iot-generic-switch), that contains a "virtualized" [**Arduino GenericPin**](https://github.com/dev-lab/arduino-generic-pin). In other words, no Arduino board is required for this project, and it can be used with pure ESP modules like Sonoff.

The software allows both to set-up and to control ESP8266 device through Web Interface.

## Features
* Operate ESP8266 ports through Web Interface;
* HTTP Server with optional authentication for 2 users: `admin` and `user` (configurable through Web interface);
* Wi-Fi configurable through Web interface (both connecting to existing Wi-Fi network and creating a new Wi-Fi Access Point (AP) with the option of disabling AP on successfull connectin to Wi-Fi network);
* In AP mode all the DNS queries are resolved to ESP8266 IP address;
* Configurable through the Web interface **Ports View**;
* Allows to send raw [commands](https://github.com/dev-lab/arduino-generic-pin#commands) through Web interface to virtual [**GenericPin**](https://github.com/dev-lab/arduino-generic-pin);
* Built-in IDE for editing the software through Web interface;
* Responsive Web UI (usable from smartphones);
* NodeMCU version agnostic (polyfills allow to work on on NodeMCU 1.5.4.1 - 3.0.0).

### Web UI Animations:

#### UI overview:
[![Web UI overview (animation)](https://github.com/dev-lab/blob/blob/master/iot-power-strip/generic-switch-web-ui-overview-pic.png)](https://github.com/dev-lab/blob/blob/master/iot-power-strip/generic-switch-web-ui-overview.gif)

#### UI overview with port configuration:
[![Web UI overview with port config (animation)](https://github.com/dev-lab/blob/blob/master/iot-power-strip/generic-switch-web-ui-overview-with-config-port-pic.png)](https://github.com/dev-lab/blob/blob/master/iot-power-strip/generic-switch-web-ui-overview-with-config-port.gif)

#### Setup Wi-Fi access point:
[![Setup Wi-Fi access point (animation)](https://github.com/dev-lab/blob/blob/master/iot-power-strip/generic-switch-web-ui-config-wifi-ap-pic.png)](https://github.com/dev-lab/blob/blob/master/iot-power-strip/generic-switch-web-ui-config-wifi-ap.gif)

#### Setup `admin` authentication:
[![Setup admin authentication (animation)](https://github.com/dev-lab/blob/blob/master/iot-power-strip/generic-switch-web-ui-config-admin-auth-pic.png)](https://github.com/dev-lab/blob/blob/master/iot-power-strip/generic-switch-web-ui-config-admin-auth.gif)

## Usage
1. Flash the ESP8266 module with the NodeMCU firmware as described in [Flashing the firmware](https://nodemcu.readthedocs.io/en/release/flash/) with any tool you like (e.g. [esptool.py](https://github.com/espressif/esptool), [NodeMCU Flasher](https://github.com/nodemcu/nodemcu-flasher) etc.). The custom NodeMCU firmware can be built online with the service: [NodeMCU custom builds](https://nodemcu-build.com/). If your ESP8266 EEPROM is only 512Kb, you have to take extra steps to be sure that firmware is as small as possible, and there is enough space for project files in EEPROM file system. So, build your custom firmware based on 1.5.4.1-final NodeMCU with the only 9 modules selected: `cjson`, `file`, `gpio`, `net`, `node`, `pwm`, `tmr`, `uart`, `wifi`, no TLS, no debug, and take the integer version of it. The firmware I built with the above options is 400004 bytes, which gave me about 78 Kb of space available in my ESP-01 EEPROM file system. In the case if your ESP module goes with larger EEPROM installed (which is the case if you are flashing a Sonoff device), you can build even the most recent NodeMCU version (select the `release` option on online build tool) with more modules selected, just make sure that at least 70Kb of file system space is available when you run NodeMCU. Make sure the following 9 modules are selected when you are building the firmware:
  * `file`;
  * "GPIO";
  * `net`;
  * `node`;
  * `SJSON` (for new NodeMCU; if you build older NodeMCU (1.5.4.1) select `cJSON` instead);
  * `PWM`;
  * `timer`;
  * `UART` (not needed for this project, but may be useful for debug, and takes 0kb of additional space in firmware);
  * `WiFi`.

  [![Flashing ESP8266 with custom NodeMCU](https://github.com/dev-lab/blob/blob/master/iot-power-strip/flash-nodemcu-pic.png)](https://github.com/dev-lab/blob/blob/master/iot-power-strip/flash-nodemcu.gif) 
  [![Contacting Sonoff using Flash Stapler](https://github.com/dev-lab/blob/blob/master/iot-power-strip/flash-stapler-sonoff.jpg)](https://www.thingiverse.com/thing:3309720) 
  
2. Upload the project files (all the files from [src/](src/) directory) to the ESP module (read the [Uploading code](https://nodemcu.readthedocs.io/en/release/upload/) how to do it). If you prefer, you can use the tool for uploading NodeMCU files from https://github.com/dev-lab/esp-nodemcu-lua-uploader. Upload the software with either [install.sh](install.sh), or [install.bat](install.bat) depending on your OS:

  [![Uploading IoT Generic Switch software into ESP8266](https://github.com/dev-lab/blob/blob/master/iot-power-strip/upload-soft-pic.png)](https://github.com/dev-lab/blob/blob/master/iot-power-strip/upload-soft.gif)
  
3. Restart the ESP8266 module (turn it off and turn back on). After restarting you will see a new Wi-Fi access point with the name: `esp-devlab-setup`. You will be able to connect to the module with the default password: `We1c0me!`. The default Wi-Fi AP name and password are specified in file: [`connect.lua`](src/connect.lua). 
4. On successfull connection to the `esp-devlab-setup` Access Point you will be able to reach the Web UI through the browser by typing anything looking like domain name as an URL, e.g.: `any.site.my`. You can do that because the software starts a DNS liar server (it responds with the ESP8266 IP to any DNS request) in AP mode. The DNS server evolved based on the work published on the following resources:
  * [Re: Tiny DNS server written in Ncat-Lua - anyone interested?](http://seclists.org/nmap-dev/2013/q3/196)
  * https://svn.nmap.org/!svn/bc/31535/nmap-exp/d33tah/lua-exec-examples/ncat/scripts/dns.lua
  * [ESP8266 WiFi Throwies](http://hackaday.com/2015/05/03/esp8266-wifi-throwies/)
  * [Wifi throwie : improved version - faster, smaller, cheaper](http://iotests.blogspot.fr/2015/10/wifi-throwie-improved-version-faster.html)
5. Web UI shall be quite self-explaining to use. You only have to remember that the best way to brick the software is to use Web IDE without checking twice what you are uploading to the file system. The changes are taken into account immediately. A bricked NodeMCU can be cured only with connecting of ESP module to computer through UART, formatting of NodeMCU file system, and rewriting the Lua software. In some cases you even have to re-flash the NodeMCU (e.g. if you did the mistake and removed the delay in [`init.lua`](src/init.lua).

## The Use Case:
The software can be used as is with the simple Sonoff devices (checked on Basic Switch and S26 Plug). For other devices, the default [`ports.json`](src/ports.json) may not work, so you will need to modify this file either directly or through ESP Web UI at runtime, using the **Ports** menu. Note, that GPIO pins are usually specified for Sonoff devices, while NodeMCU (and this software) operate with IO indexes. Use the [NodeMCU GPIO](https://nodemcu.readthedocs.io/en/release/modules/gpio/) documentation to map GPIO numbers to port indices. For example, if you find that the relay is connected to GPIO12, the corresponding NodeMCU IO index will be 6 (as you can see in [`ports.json`](src/ports.json)).

## [License](LICENSE)
Copyright (c) 2015-2021 Taras Greben 

Licensed under the [Apache License](LICENSE).
