module MobileDevicePool
  class LibImobileDevice
    @@product_type_name_map = File.open(File.join(File.dirname(__FILE__), 'ios_product_type_name_map'), 'r') do |f|
      list = {}
      while line = f.gets
        if line.match(/^#.*/).nil?
          map = line.strip.split('=')
          list[map.first] = map.last
        end
      end
      list
    end
    
    class << self
      def list_devices
        `idevice_id --list`.split("\n")
      end
      
      def list_devices_with_details
        devices = list_devices.inject([]) do |devices, udid|
          device = {}
          device['udid'] = udid
          device['model'] = get_product_name(udid)
          device['os'] = get_os_version(udid)
          device['battery'] = get_battery_level(udid)
          devices.push(device)
        end
      end
      
      def get_os_version(udid)
        get_info('ideviceinfo', udid, 'ProductVersion')
      end
      
      def get_product_name(udid)
        @@product_type_name_map[get_info('ideviceinfo', udid, 'ProductType')]
      end
      
      def get_battery_level(udid)
        get_info('ideviceinfo', udid, 'BatteryCurrentCapacity', 'com.apple.mobile.battery')
      end
      
      def install_app(file, udid)
        `ideviceinstaller -u #{udid} -i #{file}`
      end
      
      def get_info(cmd, udid, key, domain = nil)
        if domain
          `#{cmd} -u #{udid} -q #{domain} -k #{key}`.strip
        else
          `#{cmd} -u #{udid} -k #{key}`.strip
        end
      end
    end
    
    private_class_method :get_info
  end
end