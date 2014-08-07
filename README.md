[![Build Status](https://travis-ci.org/axyjo/leaflet-rails.png?branch=master)](https://travis-ci.org/axyjo/leaflet-rails)
[![Gem Version](https://badge.fury.io/rb/leaflet-rails.png)](http://badge.fury.io/rb/leaflet-rails)

Quickstart Guide
================

To start using the leaflet-rails gem, follow the steps below (assuming you use the default asset pipeline):

First, add the following code to your `Gemfile`.

```ruby
gem 'leaflet-rails'
```

Then, run `bundle install` from within your project to download the necessary files. Following that, open your application-wide CSS file (`app/assets/stylesheets/application.css`) and add the following line as a comment:

```
= require leaflet
```

After that, open your application-wide Javascript file (typically `app/assets/javascripts/application.js`) and add the following line before requiring files which depend on Leaflet:

```
= require leaflet
```

At this point, you may skip the first two steps of the [Leaflet Quick Start guide](http://leafletjs.com/examples/quick-start.html) and start at the third step (adding the map `div` to a view).

*Rails 4.1+*

If you are using Rails 4.1+ you will need to open your application-wide CSS file (`app/assets/stylesheets/application.css`) and add the following lines at the top:

```
//= depend_on_asset "layers.png"
//= depend_on_asset "layers-2x.png"
```

Helpers
=======

To get you up and running quickly, you can also use the gem's helper. To get started, add the following lines to a file called `leaflet.rb` in `config/initializers`:

```ruby
Leaflet.tile_layer = "http://{s}.tile.cloudmade.com/YOUR-CLOUDMADE-API-KEY/997/256/{z}/{x}/{y}.png"
# You can also use any other tile layer here if you don't want to use Cloudmade - see http://leafletjs.com/reference.html#tilelayer for more
Leaflet.attribution = "Your attribution statement"
Leaflet.max_zoom = 18
```

If you are using a tile layer which requires non-default subdomains such as [MapQuest-OSM Tiles](http://developer.mapquest.com/web/products/open/map), you can set the subdomains like this:

```ruby
Leaflet.tile_layer = "http://{s}.mqcdn.com/tiles/1.0.0/map/{z}/{x}/{y}.png"
Leaflet.subdomains = ['otile1', 'otile2', 'otile3', 'otile4']
```

You will then be able to call the ```#map``` helper method in a view, and make sure that the helper method is inside an erb tag like so:
```ruby
<div id="map">
  <%= map(:center => {
    :latlng => [51.52238797921441, -0.08366235665359283],
    :zoom => 18
  }) %>
</div>
```

You can also add any number of markers like so:
```ruby
map(:center => {
    :latlng => [51.52238797921441, -0.08366235665359283],
    :zoom => 18
  },
  :markers => [
    {
       :latlng => [51.52238797921441, -0.08366235665359283],
    }
  ]
)
```

To automatically zoom and position the map so all your markers are visible when it displays, add the ```fit_to_markers``` option:
```ruby
map(
  :markers => [
     {
       :latlng => [51.52238797921441, -0.08366235665359283],
       :popup => "Hello!"
     }
  ].
  :fit_to_markers => true
)
```

If you specify both ```fit_to_markers``` and ```fitbounds``` on a map, the value of ```fitbounds``` will take precendence.

Adding a `:popup` element to a marker hash will also generate a popup for a maker:

```ruby
map(:center => {
    :latlng => [51.52238797921441, -0.08366235665359283],
    :zoom => 18
  },
  :markers => [
     {
       :latlng => [51.52238797921441, -0.08366235665359283],
       :popup => "Hello!"
     }
  ]
)
```

If you want to override the map settings you have set in the initializer, you can also add them to the helper method:

```ruby
map(:center => {
    :latlng => [51.52238797921441, -0.08366235665359283],
    :zoom => 18
  },
  :tile_layer => "http://{s}.somedomain.com/somepath/{z}/{x}/{y}.png",
  :attribution => "Some other attribution text",
  :max_zoom => 4
)
```

If you want to have multiple maps on same page , you should add unique container_id in helper method for each map:

```ruby
map(:container_id => "first_map", :center => {
    :latlng => [51.52238797921441, -0.08366235665359283],
    :zoom => 18
})

map(:container_id => "second_map", :center => {
    :latlng => [51.52238797921441, -0.08366235665359283],
    :zoom => 18
})
```


[![Bitdeli Badge](https://d2weczhvl823v0.cloudfront.net/axyjo/leaflet-rails/trend.png)](https://bitdeli.com/free "Bitdeli Badge")
