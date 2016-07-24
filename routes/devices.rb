require_relative 'import'

module MobileDevicePool
  class App < Sinatra::Base
    register Sinatra::Namespace
    include ADB
    include FileHelper
    
    # APIs
    # ==================================================
    namespace '/api/devices' do
      get '/?' do
        content_type :json
        devices = list_devices_with_details
        json devices
      end
      
      # Packages
      # ==================================================
      get '/:device_sn/packages/?' do |device_sn|
        content_type :json
        json list_installed_packages(device_sn)
      end
      
      get '/:device_sn/packages/:package_name/?' do
        content_type :json
        json get_app_info(params[:package_name], params[:device_sn])
      end
      
      delete '/:device_sn/packages/:package_name/?' do
        uninstall_app(params[:package_name], params[:device_sn]) ? 204 : 404
      end
      
      delete '/:device_sn/packages/:package_name/data/?' do
        clear_app(params[:package_name], params[:device_sn]) ? 204 : 404
      end
      
      # Activities
      # ==================================================
      get '/:device_sn/activities/focused/?' do |device_sn|
        content_type :json
        json [get_current_activity(device_sn)]
      end
      
      post '/:device_sn/screenshots/?' do |device_sn|
        content_type :json
        result = take_a_screenshot(settings.screenshot_dir, device_sn)
        result.first ? [201, result[1].to_json] : [500, result[1].to_json]
      end
      
      put '/:device_sn/?' do |device_sn|
        request.body.rewind
        json = request.body.read.to_s
        if json && json.length >= 2
          req_data = JSON.parse(json)
          language = req_data['language']
          country = req_data['country']
          if language && country
            change_language(language, country, device_sn)
            return 202
          else
            return 400
          end
        else
          return 400
        end
      end
      
      post '/:device_sn/deeplinks/?' do |device_sn|
        request.body.rewind
        json = request.body.read.to_s
        if json && json.length >= 2
          req_data = JSON.parse(json)
          package_name = req_data['packageName']
          deep_link = req_data['deepLink']
          if package_name && deep_link
            result = open_app_via_deep_link(package_name, deep_link, device_sn)
            result.first ? [201, result[1].to_json] : [500, result[1].to_json]
          else
            return 500
          end
        else
          return 500
        end
      end
    end
    
    # Frontend
    # ==================================================
    namespace '/devices' do
      get '/?' do
        @use_pnotify = true
        @use_jquery_ui = true
        haml :devices
      end
    end
  end
end