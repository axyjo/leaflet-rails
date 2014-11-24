require 'active_support/inflector'
module Leaflet
  module ViewHelpers

    def map(options)
      options[:tile_layer] ||= Leaflet.tile_layer
      options[:attribution] ||= Leaflet.attribution
      options[:max_zoom] ||= Leaflet.max_zoom
      options[:subdomains] ||= Leaflet.subdomains
      options[:container_id] ||= 'map'

      tile_layer = options.delete(:tile_layer) || Leaflet.tile_layer
      attribution = options.delete(:attribution) || Leaflet.attribution
      max_zoom = options.delete(:max_zoom) || Leaflet.max_zoom
      container_id = options.delete(:container_id) || 'map'
      no_container = options.delete(:no_container)
      center = options.delete(:center)
      markers = options.delete(:markers)
      circles = options.delete(:circles)
      polylines = options.delete(:polylines)
      fitbounds = options.delete(:fitbounds)


      output = []
      output << "<div id='#{container_id}'></div>" unless no_container
      output << "<script>"
      output << "var map = L.map('#{container_id}')"

      if center
        output << "map.setView([#{center[:latlng][0]}, #{center[:latlng][1]}], #{center[:zoom]})"
      end

      if markers
        markers.each_with_index do |marker, index|
          if marker[:icon]
            if marker[:awesome_marker]
              icon_settings = prep_awesome_marker_settings(marker[:icon])
              output << "var #{icon_settings[:name]}#{index} = L.AwesomeMarkers.icon({icon: '#{icon_settings[:name]}', prefix: '#{icon_settings[:prefix]}', markerColor: '#{icon_settings[:marker_color]}', iconColor:  '#{icon_settings[:icon_color]}', spin: '#{icon_settings[:spin].to_s}', extraClasses: '#{icon_settings[:extra_classes]}'})"
            else
              icon_settings = prep_icon_settings(marker[:icon])
              output << "var #{icon_settings[:name]}#{index} = L.icon({iconUrl: '#{icon_settings[:icon_url]}', shadowUrl: '#{icon_settings[:shadow_url]}', iconSize: #{icon_settings[:icon_size]}, shadowSize: #{icon_settings[:shadow_size]}, iconAnchor: #{icon_settings[:icon_anchor]}, shadowAnchor: #{icon_settings[:shadow_anchor]}, popupAnchor: #{icon_settings[:popup_anchor]}})"
            end
            output << "marker = L.marker([#{marker[:latlng][0]}, #{marker[:latlng][1]}], {icon: #{icon_settings[:name]}#{index}}).addTo(map)"
          else
            output << "marker = L.marker([#{marker[:latlng][0]}, #{marker[:latlng][1]}]).addTo(map)"
          end
          if marker[:popup]
            output << "marker.bindPopup('#{marker[:popup]}')"
          end
        end
      end

      if circles
        circles.each do |circle|
          output << "L.circle(['#{circle[:latlng][0]}', '#{circle[:latlng][1]}'], #{circle[:radius]}, {
           color: '#{circle[:color]}',
           fillColor: '#{circle[:fillColor]}',
           fillOpacity: #{circle[:fillOpacity]}
        }).addTo(map);"
        end
      end

      if polylines
         polylines.each do |polyline|
           _output = "L.polyline(#{polyline[:latlngs]}"
           _output << "," + polyline[:options].to_json if polyline[:options]
           _output << ").addTo(map);"
           output << _output.gsub(/\n/,'')
         end
      end

      if fitbounds
        output << "map.fitBounds(L.latLngBounds(#{fitbounds}));"
      end

      output << "L.tileLayer('#{tile_layer}', {
          attribution: '#{attribution}',
          maxZoom: #{max_zoom},"

      if options[:subdomains]
        output << "    subdomains: #{options[:subdomains]},"
        options.delete( :subdomains )
      end

      options.each do |key, value|
        output << "#{key.to_s.camelize(:lower)}: '#{value}',"
      end
      output << "}).addTo(map)"

      output << "</script>"
      output.join("\n").html_safe
    end

    private

    def prep_icon_settings(settings)
      settings[:name] = 'icon' if settings[:name].nil? or settings[:name].blank?
      settings[:shadow_url] = '' if settings[:shadow_url].nil?
      settings[:icon_size] = [] if settings[:icon_size].nil?
      settings[:shadow_size] = [] if settings[:shadow_size].nil?
      settings[:icon_anchor] = [0, 0] if settings[:icon_anchor].nil?
      settings[:shadow_anchor] = [0, 0] if settings[:shadow_anchor].nil?
      settings[:popup_anchor] = [0, 0] if settings[:popup_anchor].nil?
      return settings
    end
    def prep_awesome_marker_settings(settings)
      settings[:name] = 'home' if settings[:name].blank? #icon name, corresponds to 'icon' option in awesomeMarker
      settings[:prefix] = 'glyphicon' if settings[:prefix].blank? #'fa' for font-awesome or 'glyphicon' for bootstrap 3
      settings[:marker_color] = 'blue' if settings[:marker_color].blank? # 'red', 'darkred', 'orange', 'green', 'darkgreen', 'blue', 'purple', 'darkpuple', 'cadetblue'
      settings[:icon_color] = 'white' if settings[:icon_color].blank? #'white'	'white', 'black' or css code (hex, rgba etc)
      settings[:spin] = 'false' if settings[:spin].nil? #Make the icon spin 'true' or 'false'. Font-awesome required
      settings[:extra_classes] = '' #Allow additional custom configuration.
      return settings
    end
  end


end
