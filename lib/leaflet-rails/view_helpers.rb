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
      output << "map.setView([#{options[:center][:latlng][0]}, #{options[:center][:latlng][1]}], #{options[:center][:zoom]})"
      if options[:markers]
        options[:markers].each do |marker|
          output << "marker = L.marker([#{marker[:latlng][0]}, #{marker[:latlng][1]}]).addTo(map)"
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
           output << "L.polyline(#{polyline[:latlngs]}).addTo(map);"
         end
      end

      output << "L.tileLayer('#{options[:tile_layer]}', {
          attribution: '#{options[:attribution]}',
          maxZoom: #{options[:max_zoom]}
      }).addTo(map)"
      output << "</script>"
      output.join("\n").html_safe
    end

  end

end
