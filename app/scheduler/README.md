# Scheduler
The application turns on/off configured ports on a schedule.

# Required NodeMCU modules
In addition to the modules required by [**Bare ESP8266 NodeMCU IoT Generic Switch**](https://github.com/dev-lab/bare-esp-iot-generic-switch), scheduling requires the following NodeMCU modules to be compiled:
 * `pwm` (already required by generic switch platform);
 * `rtctime`;
 * `sntp`.

# Configuration
All schedules are configured in [src/sch.json](src/sch.json) file. Here is the example of it:
```json
{"sch":{"e":1,"d":[
{"p":6,"t":[[13, 30, 23, 0]]}
]}}
```
This file schedules port with NodeMCU I/O index 6 (corresponding to GPIO12 according [NodeMCU GPIO](https://nodemcu.readthedocs.io/en/release/modules/gpio/)), to be turned on at 13:30 and to be turned off at 23:00. Note, that hour/minute in the configuration file should never be prefixed with ‘0’ (for example, for single-digit numbers). The time must be specified in UTC, so the above example is used for scheduling holiday lights in the interval 3:30pm - 1am, Kyiv time.
Several time intervals can be configured for each port (``"t"`` is an array of these intervals, which in turn are arrays of 4 numbers), and there may be other schedules configured in the file (``"d"`` is an array of those schedules). If you want to turn off all schedules, change the ``e`` (enabled) property from ```"e":1``` to ```"e":0```.
Here are some examples of useful schedules: [Holiday Lights](schedules/ny/), [Storage Water Heater](schedules/boiler/) (to use electricity to heat water at night, when it is cheaper).

# Usage
Note, that the application requires the Internet (at least initially) to synchronize the internal clock with one of the NTP servers ([0.nodemcu.pool.ntp.org through 3.nodemcu.pool.ntp.org](https://nodemcu.readthedocs.io/en/release/modules/sntp/)).
LED will flash when time is not yet synchronized, and will stop flashing when the time is successfully synchronized. When the time is synchronized, the scheduler turns the relay on or off, depending on its expected state at this time according to configured schedule. For example, if you use the schedule above: if the device is plugged on at 11am - the relay will be turned off, but if the device is plugged on at 9pm (21:00) - the relay will turn on.
Pressing a button flips the relay state. Also, the relay state can be set as usual on the Control tab of the web interface (see [**Bare ESP8266 NodeMCU IoT Generic Switch**](https://github.com/dev-lab/bare-esp-iot-generic-switch)). But when a schedule event occurs, it will take over manual (temporary) settings.
When all schedules are off (see ```"e":0``` mentioned above), the LED will indicate sleep state by constantly changing its brightness.