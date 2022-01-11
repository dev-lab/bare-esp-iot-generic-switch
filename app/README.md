# Applications
## Reasoning
By default [**Bare ESP8266 NodeMCU IoT Generic Switch**](https://github.com/dev-lab/bare-esp-iot-generic-switch) offers a lot of useful features (http server, captive portal, wifi configuration, etc.), but it doesn't allow you to automate a particular workflow with NodeMCU hardware alone (without using additional servers or automation services).
But very often the requirement for the NodeMCU device is simply to stay there and solve a real-life problem as reliably as possible, with minimal dependence on external infrastructure and with minimal interaction with human. When those devices are serving the specific needs, they are not expected to be reconfigured for other purposes, they just have to work.

Here are some examples of such requirements and the devices that implement them:
1. Internet router rebooter. Sometimes routers stop working for an unknown reason. Even those network devices that are considered reliable may fail a couple of times a year. Mankind has developed the ultimate solution for it: power off/on cycle. Therefore, the requirement for the device is to resemble what human does: to check availability of www.google.com through router's wifi, and restart the router (by turning it off and on) when the Internet disappears.
2. UVC lamp timer. Ultraviolet-C can kill Covid-19 (among other life forms), but it is not safe to turn on the lamp (you have to wear a special goggles which is sometimes inconvenient). So, the requirement is to turn on the lamp either remotely, or with a button (after some delay), and turn it off automatically after 20 minutes of exposure. The device must also work reliably without internet/intranet (operatable by a button).
3. Scheduler. Turn on/off holiday lights on schedule (when it is dark, but no one is sleeping yet), or turn on the storage water heater at night (when electricity is cheaper because everyone is asleep and not using it).

## Apps
Each of the requirements above can be implemented on top of [**Bare ESP8266 NodeMCU IoT Generic Switch**](https://github.com/dev-lab/bare-esp-iot-generic-switch), we only need to add the implementation of a particular requirement to NodeMCU device by adding/modifying a set of files on a device. This set of files to be hacked to fulfill a specific requirement will be referred to as an application (an app).

## Hardware
Some apps may require additional NodeMCU modules to be deployed (during the initial flashing). This means that these apps also require a device with more than 512Kb of flash memory. The good news is that many existing NodeMCU-capable hardware has 1Mb (or even more) of flash memory. For example, **Sonoff Basic Switch**, **Sonoff S26 Plug**, **Sonoff S26R2 Plug** all have 1Mb of flash, which is "ought to be enough for anybody".
Therefore, whenever I have ESP device with 1Mb (or more), I usually flash it with the latest NodeMCU (3.0.0 for the moment), and with the set of modules that are either required for generic functionality, or look promissing to be be used later for some apps. Here is the set of those modules:
 * `encoder`;
 * `file`;
 * `gpio`;
 * `i2c`;
 * `mqtt`;
 * `net`;
 * `node`;
 * `pwm`;
 * `pwm2`;
 * `rtcfifo`;
 * `rtcmem`;
 * `rtctime`;
 * `sjson`;
 * `sntp`;
 * `spi`;
 * `tmr`;
 * `uart`;
 * `wifi`;
 * `tls`.

## Source code
Each application is located in a separate subfolder of this folder. All application's folders have a similar structure: an application described in the ``README.md`` file, and all source files (to be added/modified on NodeMCU device) are located in ``./src`` subfolder.
Each application is written as a hack of  [**Bare ESP8266 NodeMCU IoT Generic Switch**](https://github.com/dev-lab/bare-esp-iot-generic-switch) to run on NodeMCU hardware with certain peripherals attached. If ``README.md`` for the application doesn't explicitly mention the requirement for peripherals, the necesary hardware is:

* Button, attached to IO index 3 (GPIO0),
* LED, attached to IO index 7 (GPIO13),
* Relay, attached to IO index 6 (GPIO12).

By a pure coincidence, these peripherals are available in any of **Sonoff Basic Switch**, **Sonoff S26 Plug**, **Sonoff S26R2 Plug**, at the above I/O indices. So, these I/O port indexes are hardcoded in applications. If other NodeMCU-compatible harware is equipped with the same peripherals (connected to the same ports), it is likely that the app can be used on that hardware without modifications.

## Deployment
An application can be deployed either during the initial file upload to the device, or when the device (based on [**Bare ESP8266 NodeMCU IoT Generic Switch**](https://github.com/dev-lab/bare-esp-iot-generic-switch)) is already in use, via the IDE tab of the web UI (just modify/create all files located in ``app/src`` using web interface).
Before deploying the applicaon, make sure that the NodeMCU on the device contains all the required modules for the application.
