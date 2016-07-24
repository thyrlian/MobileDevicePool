module MobileDevicePool
  class LibImobileDevice
    class << self
      def list_devices
        `idevice_id --list`.split("\n")
      end
      
      def show_battery_level(udid)
        get_info('ideviceinfo', udid, 'BatteryCurrentCapacity', 'com.apple.mobile.battery')
      end
      
      def get_info(cmd, udid, key, domain = nil)
        if domain
          `#{cmd} -u #{udid} -q #{domain} -k #{key}`.strip
        else
          `#{cmd} -u #{udid} -k #{key}`.strip
        end
      end
    end
  end
end