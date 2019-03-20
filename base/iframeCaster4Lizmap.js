lizMap.events.on({
                        uicreated: function(e) {
                            var frameSrc =  'https://pip.sig.inra.fr';
                            lizMap.addDock(
                                'Caster',
                                'Sourcetable',
                                'right-dock',
                                '<iframe src="' + frameSrc + '" height="800px" width="1500px">',
                                'icon-folder-open'
                            );
                        }
});
