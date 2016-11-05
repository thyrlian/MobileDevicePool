MobileDevicePool
===========

Web UI to manage your mobile devices kingdom.  Currently support Android and iOS devices.

Forked from my own project: [**Captain-ADB**](https://github.com/thyrlian/Captain-ADB)

## Demo
<img src="https://github.com/thyrlian/MobileDevicePool/blob/master/public/img/demo.png">

## Setup

* Run `bundle install` to install all ruby dependencies
* Install [libimobiledevice](https://github.com/libimobiledevice/libimobiledevice) (iOS devices communication tool)
* Install [ideviceinstaller](https://github.com/libimobiledevice/ideviceinstaller) (manage apps on iOS devices)

## Setup on [Raspbian](https://www.raspberrypi.org/downloads/raspbian/)

* `sudo gem install bundler`
* `bundle install`
* `sudo apt-get install libimobiledevice4 libimobiledevice-utils ideviceinstaller usbmuxd`
* Download and install [Android SDK](https://developer.android.com/studio/index.html)

## Run Service

Run `rackup -p <PORT>` and the open `http://localhost:<PORT>/` in the browser 

## License
Copyright (c) 2016 Jing Li. See the [LICENSE](https://github.com/thyrlian/MobileDevicePool/blob/master/LICENSE) file for details.
