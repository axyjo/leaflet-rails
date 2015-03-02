require 'spec_helper'

describe Leaflet::ViewHelpers do
  
  class TestView < ActionView::Base
  end
  
  before :all do
    Leaflet.tile_layer = "http://{s}.somedomain.com/blabla/{z}/{x}/{y}.png"
    Leaflet.attribution = "Some attribution statement"
    Leaflet.max_zoom = 18
    
    @view = TestView.new
  end
  
  it 'should mix in view helpers on initialization' do
    @view.should respond_to(:map)
  end
  
  it 'should set the method configuration options' do    
    result = @view.map(:center => {
	      :latlng => [51.52238797921441, -0.08366235665359283],
	      :zoom => 18
	  	})
	  
	  result.should match(/L.tileLayer\('http:\/\/{s}.somedomain\.com\/blabla\/{z}\/{x}\/{y}\.png'/)
	  result.should match(/attribution: 'Some attribution statement'/)
	  result.should match(/maxZoom: 18/)
  end
  
  it 'should generate a basic map with the correct latitude, longitude and zoom' do
    result = @view.map(:center => {
	      :latlng => [51.52238797921441, -0.08366235665359283],
	      :zoom => 18
	  	})
	  result.should match(/map\.setView\(\[51.52238797921441, -0.08366235665359283\], 18\)/)
  end
  
  it 'should generate a basic map with the correct scrollWhellZoom option' do
    result = @view.map(
      :center => {
        :latlng => [51.52238797921441, -0.08366235665359283],
        :zoom => 18
      },
      :interaction => {
        :scrollWheelZoom => false
      }
    )
    result.should match(/var map = L.map\('map', {"scrollWheelZoom":false}\)/)
  end

  it 'should generate a marker' do
    result = @view.map(:center => {
	      :latlng => [51.52238797921441, -0.08366235665359283],
	      :zoom => 18
	  	},
	  	:markers => [
           {
             :latlng => [51.52238797921441, -0.08366235665359283],
           }
        ])
    result.should match(/marker = L\.marker\(\[51.52238797921441, -0.08366235665359283\]\).addTo\(map\)/)
  end
  
  it 'should generate a marker with a popup' do
    result = @view.map(:center => {
	      :latlng => [51.52238797921441, -0.08366235665359283],
	      :zoom => 18
	  	},
	  	:markers => [
           {
             :latlng => [51.52238797921441, -0.08366235665359283],
             :popup => "Hello!"
           }
        ])
    result.should match(/marker = L\.marker\(\[51.52238797921441, -0.08366235665359283\]\).addTo\(map\)/)
    result.should match(/marker\.bindPopup\('Hello!'\)/)
  end

  it 'should generate a marker with a popup and a custom icon' do
    icon_options = { :name => 'house',
                     :icon_url => 'images/house.png',
                     :shadow_url => 'images/house_shadow.png',
                     :icon_size => [38, 95],
                     :shadow_size => [50, 64],
                     :icon_anchor => [22, 94],
                     :shadow_anchor => [4, 62],
                     :popup_anchor => [-3, -76]}
    result = @view.map(:center => {
        :latlng => [51.52238797921441, -0.08366235665359283],
        :zoom => 18
    },
    :markers => [
         {
             :latlng => [51.52238797921441, -0.08366235665359283],
             :popup => "Hello!",
             :icon => icon_options
         }
     ])
    expected_icon_def = "var #{icon_options[:name]}0 = L.icon({iconUrl: '#{icon_options[:icon_url]}', shadowUrl: '#{icon_options[:shadow_url]}', iconSize: #{icon_options[:icon_size]}, shadowSize: #{icon_options[:shadow_size]}, iconAnchor: #{icon_options[:icon_anchor]}, shadowAnchor: #{icon_options[:shadow_anchor]}, popupAnchor: #{icon_options[:popup_anchor]}})"
    result.should include(expected_icon_def)
    result.should match(/marker = L\.marker\(\[51.52238797921441, -0.08366235665359283\], \{icon: house\d+\}\).addTo\(map\)/)
    result.should match(/marker\.bindPopup\('Hello!'\)/)
  end

  it 'should generate many markers with popups and custom icons' do
    icon_options = { :name => 'house',
                     :icon_url => 'images/house.png',
                     :shadow_url => 'images/house_shadow.png',
                     :icon_size => [38, 95],
                     :shadow_size => [50, 64],
                     :icon_anchor => [22, 94],
                     :shadow_anchor => [4, 62],
                     :popup_anchor => [-3, -76]}
    result = @view.map(:center => {
        :latlng => [51.52238797921441, -0.08366235665359283],
        :zoom => 18
      },
       :markers => [
           {
               :latlng => [51.52238797921441, -0.08366235665359283],
               :popup => "Hello!",
               :icon => icon_options
           },
           {
               :latlng => [51.54238797921441, -0.08566235665359283],
               :popup => "Farewell!",
               :icon => icon_options
           }
       ])
    expected_icon_def_1 = "var #{icon_options[:name]}0 = L.icon({iconUrl: '#{icon_options[:icon_url]}', shadowUrl: '#{icon_options[:shadow_url]}', iconSize: #{icon_options[:icon_size]}, shadowSize: #{icon_options[:shadow_size]}, iconAnchor: #{icon_options[:icon_anchor]}, shadowAnchor: #{icon_options[:shadow_anchor]}, popupAnchor: #{icon_options[:popup_anchor]}})"
    expected_icon_def_2 = "var #{icon_options[:name]}1 = L.icon({iconUrl: '#{icon_options[:icon_url]}', shadowUrl: '#{icon_options[:shadow_url]}', iconSize: #{icon_options[:icon_size]}, shadowSize: #{icon_options[:shadow_size]}, iconAnchor: #{icon_options[:icon_anchor]}, shadowAnchor: #{icon_options[:shadow_anchor]}, popupAnchor: #{icon_options[:popup_anchor]}})"
    result.should include(expected_icon_def_1)
    result.should include(expected_icon_def_2)
    result.should match(/marker = L\.marker\(\[51.52238797921441, -0.08366235665359283\], \{icon: house\d+\}\).addTo\(map\)/)
    result.should match(/marker = L\.marker\(\[51.54238797921441, -0.08566235665359283\], \{icon: house\d+\}\).addTo\(map\)/)
    result.should match(/marker\.bindPopup\('Hello!'\)/)
    result.should match(/marker\.bindPopup\('Farewell!'\)/)
  end

  it 'should have defaults for icon options' do
    icon_options = { :icon_url => 'images/house.png'}
    result = @view.map(:center => {
        :latlng => [51.52238797921441, -0.08366235665359283],
        :zoom => 18
    },
     :markers => [
         {
             :latlng => [51.52238797921441, -0.08366235665359283],
             :popup => "Hello!",
             :icon => icon_options
         }
     ])
    expected_icon_def = "var icon0 = L.icon({iconUrl: '#{icon_options[:icon_url]}', shadowUrl: '', iconSize: [], shadowSize: [], iconAnchor: [0, 0], shadowAnchor: [0, 0], popupAnchor: [0, 0]})"
    result.should include(expected_icon_def)
    result.should match(/marker = L\.marker\(\[51.52238797921441, -0.08366235665359283\], \{icon: icon\d+\}\).addTo\(map\)/)
    result.should match(/marker\.bindPopup\('Hello!'\)/)
  end
  
  it 'should override the method configuration options if set' do
    result = @view.map(:center => {
	      :latlng => [51.52238797921441, -0.08366235665359283],
	      :zoom => 18
	  	},
	  	:tile_layer => "http://{s}.someotherdomain.com/blabla/{z}/{x}/{y}.png",
	  	:attribution => "Some other attribution text",
	  	:max_zoom => 4
	  	)
	  
  	  result.should match(/L.tileLayer\('http:\/\/{s}.someotherdomain\.com\/blabla\/{z}\/{x}\/{y}\.png'/)
  	  result.should match(/attribution: 'Some other attribution text'/)
  	  result.should match(/maxZoom: 4/)
  end

  it 'should pass any configuration options to L.tileLayer if set' do
    result = @view.map(:center => {
        :latlng => [51.52238797921441, -0.08366235665359283],
        :zoom => 18
      },
      :tile_layer => "http://{s}.someotherdomain.com/blabla/{z}/{x}/{y}.png",
      :attribution => "Some other attribution text",
      :max_zoom => 4,
      :some_key => 'some value',
      :key2 => 42
      )

      result.should match(/L.tileLayer\('http:\/\/{s}.someotherdomain\.com\/blabla\/{z}\/{x}\/{y}\.png'/)
      result.should match(/attribution: 'Some other attribution text'/)
      result.should match(/maxZoom: 4/)
      result.should match(/someKey: 'some value'/)
      result.should match(/key2: '42'/)

  end

  it 'should have multiple map on single page' do
    result = @view.map(:container_id => "first_map", :center => {
              :latlng => [51.52238797921441, -0.08366235665359283],
                })

    result1 = @view.map(:container_id => "second_map", :center => {
              :latlng => [51.62238797921441, -0.08366235665359284],
                })

          result.should match(/id=\'first_map'/)
          result.should match(/L.map\('first_map'/)

          result1.should match(/id=\'second_map'/)
          result1.should match(/L.map\('second_map'/)

  end
 
  it 'should generate a map and add a circle' do
    result = @view.map(
                :container_id => "first_map",
                :center => {
                  :latlng => [51.52238797921441, -0.08366235665359283]
                },
                :circles => [
                  {
                    :latlng => [51.52238797921441, -0.08366235665359283],
                    :radius => 12,
                    :color => 'red',
                    :fillColor => '#f03',
                    :fillOpacity => 0.5
                  }
                  ])
    result.should match(/L.circle\(\[\'51.52238797921441\', \'-0.08366235665359283\'\], 12, \{
           color: \'red\',
           fillColor: \'#f03\',
           fillOpacity: 0.5
        \}\).addTo\(map\)/)
  end

  it 'should not create the container tag if no_container is set' do
    result = @view.map(:center => {
        :latlng => [51.52238797921441, -0.08366235665359283],
        :zoom => 18
      },
      :no_container => true
      )

    result.should_not match(/<div id='map'>/)
  end

  it 'should generate a map and add a polyline' do
    result = @view.map(
                :polylines => [{:latlngs => [[51.5, -0.08], [-51.5, 0.08]], :options => {:color => "green"}}]
                )
    result.should match(Regexp.quote('L.polyline([[51.5, -0.08], [-51.5, 0.08]],{"color":"green"}).addTo(map);'))
  end

  it 'should generate a map and add fitbounds' do
    result = @view.map(
                :fitbounds => [[51.5, -0.08],[-51.5, 0.08]]
                )
    result.should match(Regexp.quote("map.fitBounds(L.latLngBounds([[51.5, -0.08], [-51.5, 0.08]]));"))
  end

  it 'should not require a center option to generate a map' do
    result = @view.map({})
    result.should_not match(Regexp.quote("map.setView"))
  end
end
