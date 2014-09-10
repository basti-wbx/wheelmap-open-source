//= require angular
//= require leaflet/leaflet-src
//= require angular/angular-leaflet-directive

var app = angular.module("wheelmap", ["leaflet-directive"]);

app.controller("GeoJSONController", [ '$scope', '$http', '$templateCache', '$compile', '$location', function($scope, $http, $templateCache, $compile, $location) {
    angular.extend($scope, {
        berlin: {
            lat: 52.50521,
            lng: 13.4231,
            zoom: 10
        },
        tiles: {
            url: 'http://{s}.tiles.mapbox.com/v3/sozialhelden.map-iqt6py1k/{z}/{x}/{y}.png256',
            options: {
                maxZoom: 19,
                minZoom: 2,
                attribution: 'Data: <a href="http://www.openstreetmap.org/copyright">&copy; OpenStreetMap contributors</a>, Icons: CC-By-SA <a href="http://mapicons.nicolasmollet.com/">Nicolas Mollet</a>',
                detectRetina: true
            }
        },
        events: {
            map: {
                enable: ['zoomend', 'dragend', 'popupopen', 'popupclose'],
                logic: 'emit'
            }
        }
    });

    function loadData() {
        if ($scope.bounds == null) {
            return;
        }

        // Get the countries geojson data from a JSON
        $http({
            method: 'GET',
            params: {
                bbox: [
                    $scope.bounds.southWest.lng,
                    $scope.bounds.southWest.lat,
                    $scope.bounds.northEast.lng,
                    $scope.bounds.northEast.lat
                ].join(',')
            },
            url: '/nodes.geojson'
        }).success(function(data, status) {
            angular.extend($scope, {
                geojson: {
                    data: data
                }
            });
        });
    }

    $scope.$on('leafletDirectiveMap.geojsonClick', function(event, selected, leafletEvent) {
        var marker = leafletEvent.target,
            template = $compile(angular.element($templateCache.get('popup.html')));

        $scope.test = 'bla';
        $scope.clickPopup = function() {
            console.log(selected);
        };

        marker.bindPopup(template($scope)[0]);
        marker.openPopup();

        $location.search('node_id', selected.properties.id);
    });

    $scope.$on('leafletDirectiveMap.popupclose', function() {
        $location.search('node_id', null);
    });

    $scope.$watch('bounds', function() {
        loadData();
    });

    $scope.$on('$locationChangeSuccess', function() {
        
    });
}]);