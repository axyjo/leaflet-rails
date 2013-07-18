require "leaflet-rails/version"

module Leaflet
  module Rails
    class Engine < ::Rails::Engine
      initializer 'leaflet-rails.precompile' do |app|
        app.config.assets.precompile += %w(layers-2x.png layers.png marker-icon-2x.png marker-icon.png marker-shadow.png)
      end
    end
  end
end
