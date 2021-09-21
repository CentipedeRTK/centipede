var map_crs = "EPSG:3857"
var local_crs = "EPSG:2154"  // 3857 is very bad for doing a buffer in meters, so better to use a local projection
var radius = 10000; // in local crs unit
var radius2 = 20000; // in local crs unit
var radius3 = 30000; // in local crs unit
var radius4 = 40000; // in local crs unit
var radius5 = 50000; // in local crs unit
var text_add = 'Tampons 10km'
var text_remove = 'Supprimer tampons'

lizMap.events.on({
    'uicreated':function(evt){

        lizMap.map.addLayer(new OpenLayers.Layer.Vector('buffer_dynamic',{
            styleMap: new OpenLayers.StyleMap({
                pointRadius: 3,
                fill: false,
                fillOpacity: 0.2,
                stroke: true,
                strokeWidth: 2,
                strokeColor: 'blue',
                strokeOpacity: 0.5
            })
        }));
        var bufferDynamic = lizMap.map.getLayersByName('buffer_dynamic')[0];

        var html = '<button id="bufferButton" class="btn btn-primary btn-lg">' + text_add + '</button>';
        $('#map-content').append(html);
        $('#bufferButton')
           .css('position', 'absolute')
           .css('top', '30px')
           .css('z-index', '1000')
           .css('margin-left', 'calc(50% - 80px)');

        lizMap.map.events.register('moveend', this, function() {
            if( $('#bufferButton').text() == text_remove ){
                drawBuffer();
            }
        });

        function drawBuffer() {
            bufferDynamic.removeAllFeatures();
            point = lizMap.map.center;
            var center_point = new OpenLayers.Geometry.Point(point.lon, point.lat);
            center_point.transform(map_crs, local_crs);
            var circle = OpenLayers.Geometry.Polygon.createRegularPolygon(center_point, radius, 30);
            circle.transform(local_crs, map_crs)
            var circleFeature = new OpenLayers.Feature.Vector(circle);
            center_point.transform(local_crs, map_crs);
            var pointFeature = new OpenLayers.Feature.Vector(center_point);
            bufferDynamic.addFeatures([circleFeature, pointFeature]);

            var center_point2 = new OpenLayers.Geometry.Point(point.lon, point.lat);
            center_point2.transform(map_crs, local_crs);
            var circle2 = OpenLayers.Geometry.Polygon.createRegularPolygon(center_point2, radius2, 40);
            circle2.transform(local_crs, map_crs)
            var circleFeature2 = new OpenLayers.Feature.Vector(circle2);
            center_point2.transform(local_crs, map_crs);
            var pointFeature2 = new OpenLayers.Feature.Vector(center_point);
            bufferDynamic.addFeatures([circleFeature2, pointFeature2]);

            var center_point3 = new OpenLayers.Geometry.Point(point.lon, point.lat);
            center_point3.transform(map_crs, local_crs);
            var circle3 = OpenLayers.Geometry.Polygon.createRegularPolygon(center_point3, radius3, 50);
            circle3.transform(local_crs, map_crs)
            var circleFeature3 = new OpenLayers.Feature.Vector(circle3);
            center_point3.transform(local_crs, map_crs);
            var pointFeature3 = new OpenLayers.Feature.Vector(center_point);
            bufferDynamic.addFeatures([circleFeature3, pointFeature3]);

            var center_point4 = new OpenLayers.Geometry.Point(point.lon, point.lat);
            center_point4.transform(map_crs, local_crs);
            var circle4 = OpenLayers.Geometry.Polygon.createRegularPolygon(center_point4, radius4, 60);
            circle4.transform(local_crs, map_crs)
            var circleFeature4 = new OpenLayers.Feature.Vector(circle4);
            center_point4.transform(local_crs, map_crs);
            var pointFeature4 = new OpenLayers.Feature.Vector(center_point);
            bufferDynamic.addFeatures([circleFeature4, pointFeature4]);

            var center_point5 = new OpenLayers.Geometry.Point(point.lon, point.lat);
            center_point5.transform(map_crs, local_crs);
            var circle5 = OpenLayers.Geometry.Polygon.createRegularPolygon(center_point5, radius5, 70);
            circle5.transform(local_crs, map_crs)
            var circleFeature5 = new OpenLayers.Feature.Vector(circle5);
            center_point5.transform(local_crs, map_crs);
            var pointFeature5 = new OpenLayers.Feature.Vector(center_point);
            bufferDynamic.addFeatures([circleFeature5, pointFeature5]);
        }

        $('#bufferButton').click(function(){
            if( $(this).text() == text_add ){
                drawBuffer();
                $(this).text(text_remove);
            } else {
                bufferDynamic.removeAllFeatures();
                $(this).text(text_add);
            }
        });
    }
});

