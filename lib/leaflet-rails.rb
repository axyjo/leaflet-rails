require "leaflet-rails/version"
require "leaflet-rails/view_helpers"
require "rails"

module Leaflet
  mattr_accessor :tile_layer
  mattr_accessor :attribution
  mattr_accessor :max_zoom
  mattr_accessor :subdomains
  
  module Rails
    class Engine < ::Rails::Engine
      initializer 'leaflet-rails.precompile' do |app|
        if app.config.respond_to? (:assets)
          app.config.assets.precompile += %w(layers-2x.png layers.png marker-icon-2x.png marker-icon.png marker-shadow.png)
        end
      end

      initializer 'leaflet-rails.helpers' do
        ActionView::Base.send :include, Leaflet::ViewHelpers
      end
    end
  end
end
