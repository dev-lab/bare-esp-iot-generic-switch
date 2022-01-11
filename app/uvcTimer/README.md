# UV-C Timer
The application allows to safely turn on UV-C lamp for 20 minutes.

# Required modules
Make sure that `pwm` module is compiled along with NodeMCU, but is is already required by [**Bare ESP8266 NodeMCU IoT Generic Switch**](https://github.com/dev-lab/bare-esp-iot-generic-switch). 

# Usage
Power UV-C lamp through the NodeMCU device with this app installed. When the device starts, the relay is off (so the connected UV-C lamp is off too). There are two ways to turn on the relay for 20 minutes:
1. Being remote to the device, by pressing "On" button on Control tab of the Web interface (see [**Bare ESP8266 NodeMCU IoT Generic Switch**](https://github.com/dev-lab/bare-esp-iot-generic-switch)). The relay switches on immediately and switches off in 20 minutes. 
2. By pressing the physical button on NodeMCU device. In this case, the LED will flash and the relay will turn on after about 15 seconds of delay. That will give you some time to leave the room unexposed to UV-C light. When the LED flashes, you still have a chance to cancel turning on the relay by pressing the button again (the LED will stop flashing, which means that the relay will not be switched on).