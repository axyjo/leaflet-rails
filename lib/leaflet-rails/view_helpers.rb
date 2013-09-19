module Leaflet
  module ViewHelpers
  
    def map(options)
      options[:tile_layer] ||= Leaflet.tile_layer
      options[:attribution] ||= Leaflet.attribution
      options[:max_zoom] ||= Leaflet.max_zoom
      
      output = []
      output << "<div id='map'></div>"
      output << "<script>"
      output << "var map = L.map('map')"
      output << "map.setView([#{options[:center][:latlng][0]}, #{options[:center][:latlng][1]}], #{options[:center][:zoom]})"
      if options[:markers]
        options[:markers].each do |marker|
          output << "marker = L.marker([#{marker[:latlng][0]}, #{marker[:latlng][1]}]).addTo(map)"
          if marker[:popup]
            output << "marker.bindPopup('#{marker[:popup]}')"
          end
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