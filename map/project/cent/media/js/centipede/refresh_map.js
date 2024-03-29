
lizMap.events.on({

    'uicreated': function(e) {

        // List of layer QGIS names to refresh
        rlayers = [
            'buffer',
            'basesrtk'
        ];

        // Refresh interval in milliseconds
        var refreshInterval = 10000;

        // ****
        // Do not edit below
        // ****

        // Get layers by name
        var tlayers = [];
        for(var i in rlayers){
            var olayers = lizMap.map.getLayersByName(rlayers[i]);
            if( olayers.length > 0 ){
                for(var l in olayers){
                    var layer = olayers[l];
                    tlayers.push(layer);
                }
            }
        }

        // Refresh all given layers
        function refreshLayers() {
            for( var l in tlayers ){
                if( tlayers[l].visibility ){
                    tlayers[l].redraw(true);
                }
            }
        }

        // Set timer to refresh layers every N milliseconds
        var tid = setInterval(refreshLayers, refreshInterval);
    }

});
