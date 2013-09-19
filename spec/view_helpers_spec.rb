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
  
end