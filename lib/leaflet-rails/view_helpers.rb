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
      geojsons = options.delete(:geojsons)
      fitbounds = options.delete(:fitbounds)
      subdomains = options.delete(:subdomains)

      output = []
      output << "<div id='#{container_id}'></div>" unless no_container
      output << "<script>"
      output << "var map = L.map('#{container_id}', {#{options.map{|k,v| "#{k}: #{v}"}.join(', ')}});"

      if center
        output << "map.setView([#{center[:latlng][0]}, #{center[:latlng][1]}], #{center[:zoom]});"
      end

      if markers
        markers.each_with_index do |marker, index|
          if marker[:icon]
            icon_settings = prep_icon_settings(marker[:icon])
            output << "var #{icon_settings[:name]}#{index} = L.icon({iconUrl: '#{icon_settings[:icon_url]}', shadowUrl: '#{icon_settings[:shadow_url]}', iconSize: #{icon_settings[:icon_size]}, shadowSize: #{icon_settings[:shadow_size]}, iconAnchor: #{icon_settings[:icon_anchor]}, shadowAnchor: #{icon_settings[:shadow_anchor]}, popupAnchor: #{icon_settings[:popup_anchor]}});"
            output << "marker = L.marker([#{marker[:latlng][0]}, #{marker[:latlng][1]}], {icon: #{icon_settings[:name]}#{index}}).addTo(map);"
          else
            output << "marker = L.marker([#{marker[:latlng][0]}, #{marker[:latlng][1]}]).addTo(map);"
          end
          if marker[:popup]
            output << "marker.bindPopup('#{escape_javascript marker[:popup]}');"
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

      if geojsons
        geojsons.each do |geojson|
          _output = "L.geoJSON(#{geojson[:geojson]}"
          if geojson[:options]
            options = geojson[:options]
            on_each_feature = options.delete(:onEachFeature)
            if on_each_feature
              options[:onEachFeature] = ':onEachFeature'
            end
            _output << "," + options.to_json.gsub('":onEachFeature"', on_each_feature)
          end
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

      if subdomains
        output << "    subdomains: #{subdomains},"
      end

      options.each do |key, value|
        output << "#{key.to_s.camelize(:lower)}: '#{value}',"
      end
      output << "}).addTo(map);"

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
  end

end
