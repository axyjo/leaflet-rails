require "leaflet-rails/version"
require "leaflet-rails/view_helpers"

module Leaflet
  mattr_accessor :tile_layer
  mattr_accessor :attribution
  mattr_accessor :max_zoom
  mattr_accessor :subdomains

  module Rails
    class Engine < ::Rails::Engine
      initializer 'leaflet-rails.precompile' do |app|
        app.config.assets.precompile += %w(layers-2x.png layers.png marker-icon-2x.png marker-icon.png marker-shadow.png)
        app.config.assets.precompile += %w(markers-matte.png markers-matte@2x.pnd markers-plain.png markers-shadow.png markers-soft.png markers-soft@2x.png)
      end

      initializer 'leaflet-rails.helpers' do
        ActionView::Base.send :include, Leaflet::ViewHelpers
      end
    end
  end
end
