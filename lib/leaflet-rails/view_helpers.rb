module Leaflet
  module ViewHelpers

    def map(options)
      options[:tile_layer] ||= Leaflet.tile_layer
      options[:attribution] ||= Leaflet.attribution
      options[:max_zoom] ||= Leaflet.max_zoom
      options[:container_id] ||= 'map'

      output = []
      output << "<div id='#{options[:container_id]}'></div>" unless options[:no_container]
      output << "<script>"
      output << "var map = L.map('#{options[:container_id]}')"
      if options[:center]
        output << "map.setView([#{options[:center][:latlng][0]}, #{options[:center][:latlng][1]}], #{options[:center][:zoom]})"
      end
      if options[:markers]
        options[:markers].each_with_index do |marker, index|
          if marker[:icon]
            icon_settings = prep_icon_settings(marker[:icon])
            output << "var #{icon_settings[:name]}#{index} = L.icon({iconUrl: '#{icon_settings[:icon_url]}', shadowUrl: '#{icon_settings[:shadow_url]}', iconSize: #{icon_settings[:icon_size]}, shadowSize: #{icon_settings[:shadow_size]}, iconAnchor: #{icon_settings[:icon_anchor]}, shadowAnchor: #{icon_settings[:shadow_anchor]}, popupAnchor: #{icon_settings[:popup_anchor]}})"
            output << "marker = L.marker([#{marker[:latlng][0]}, #{marker[:latlng][1]}], {icon: #{icon_settings[:name]}#{index}}).addTo(map)"
          else
            output << "marker = L.marker([#{marker[:latlng][0]}, #{marker[:latlng][1]}]).addTo(map)"
          end
          if marker[:popup]
            output << "marker.bindPopup('#{marker[:popup]}')"
          end
        end
      end

      if options[:circles]
        options[:circles].each do |circle|
          output << "L.circle(['#{circle[:latlng][0]}', '#{circle[:latlng][1]}'], #{circle[:radius]}, {
           color: '#{circle[:color]}',
           fillColor: '#{circle[:fillColor]}',
           fillOpacity: #{circle[:fillOpacity]}
        }).addTo(map);"
        end
      end

      if options[:polylines]
         options[:polylines].each do |polyline|
           _output = "L.polyline(#{polyline[:latlngs]}"
           _output << "," + polyline[:options].to_json if polyline[:options]
           _output << ").addTo(map);"
           output << _output.gsub(/\n/,'')
         end
      end

      if options[:fitbounds]
        output << "map.fitBounds(L.latLngBounds(#{options[:fitbounds]}));"
      end

      output << "L.tileLayer('#{options[:tile_layer]}', {
          attribution: '#{options[:attribution]}',
          maxZoom: #{options[:max_zoom]}
      }).addTo(map)"
      output << "</script>"
      output.join("\n").html_safe
    end

    private

    def prep_icon_settings(settings)
      settings[:name] = 'icon' if settings[:name].nil? or settings[:name].blank?
      settings[:shadow_url] = '' if settings[:shadow_url].nil?
      settings[:icon_size] = [] if settings[:icon_size].nil?
      settings[:shadow_size] = [] if settings[:shadow_size].nil?
      settings[:icon_anchor] = [] if settings[:icon_anchor].nil?
      settings[:shadow_anchor] = [] if settings[:shadow_anchor].nil?
      settings[:popup_anchor] = [] if settings[:popup_anchor].nil?
      return settings
    end
  end

end
