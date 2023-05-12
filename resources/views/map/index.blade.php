<x-master-layout :assets="$assets ?? []">
<div class="container-fluid">
    <div class="row">            
        <div class="col-lg-12">
            <div class="card card-block card-stretch">
                <div class="card-body p-0">
                    <div class="d-flex justify-content-between align-items-center p-3">
                        <h5 class="font-weight-bold">{{ $pageTitle }}</h5>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="row">
        <div class="col-md-12">
            <div class="card">
                <div class="card-body">
                    <div id="map" style="height: 600px;"></div>
                    <div id="maplegend" class="d-none">
                        
                        <div>
                            <img src="{{ asset('images/online.png') }}" /> {{ __('message.online') }}
                        </div>
                        <div>
                            <img src="{{ asset('images/ontrip.png') }}" /> {{ __('message.in_service') }}
                        </div>
                        <div>
                            <img src="{{ asset('images/offline.png') }}" /> {{ __('message.offline') }}
                        </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
@section('bottom_script')
    <script>
        $(function(){
            let map;
            var marker = undefined;
            var locations = [];
            var taxiicon = ""
            $(document).ready( function() {
                driverList(); 
            });
            function initialize() {
                var myLatlng = new google.maps.LatLng(20.947940, 72.955786);
                var myOptions = {
                    zoom: 1.5,
                    center: myLatlng,
                    mapTypeId: google.maps.MapTypeId.ROADMAP
                }
                map = new google.maps.Map(document.getElementById('map'), myOptions);
                const legend = document.getElementById("maplegend");

                map.controls[google.maps.ControlPosition.RIGHT_BOTTOM].push(legend)
            }

            function changeMarkerPositions(locations)
            {
                var infowindow = new google.maps.InfoWindow();
                var markers = {};
                if(locations.length > 0 )
                {
                    for(i = 0 ; i < locations.length ; i++) {
                        // console.log("new "+locations[i].latitude, locations[i].longitude);
                    
                        if(markers[locations[i].id] ){
                            markers[locations[i].id].setMap(null); // set markers setMap to null to remove it from map
                            delete markers[locations[i].id]; // delete marker instance from markers object
                        }
                        
                        if( locations[i].is_online == 1 && locations[i].is_available == 0) {
                            taxicon = "{{ asset('images/ontrip.png') }}";
                        } else if( locations[i].is_online == 1 ) {
                            taxicon = "{{ asset('images/online.png') }}";
                        } else {
                            taxicon = "{{ asset('images/offline.png') }}";
                        }
                        marker = new google.maps.Marker({
                            position:  new google.maps.LatLng( parseFloat(locations[i].latitude)  + (Math.random() -.5) / 1500, parseFloat(locations[i].longitude) + (Math.random() -.5) / 1500 ),
                            map: map,
                            icon: taxicon,
                            title: locations[i].display_name,
                            driver_id: locations[i].id
                        });
                        marker.metadata= { id : locations[i].id };
                        
                        google.maps.event.addListener(marker, 'click', (function (marker, i) {
                            return function () {
                                driver = driverDetail(marker.driver_id);
                                service_name = driver.driver_service != null ? driver.driver_service.name : '-';
                                last_location_update_at = driver.last_location_update_at != null ? driver.last_location_update_at : '-';
                                driver_view = "{{ route('driver.show', '' ) }}/"+marker.driver_id;
                                contentString = '<div class="map_driver_detail"><ul class="list-unstyled mb-0">'+
                                '<li><i class="fa fa-address-card" aria-hidden="true"></i>: '+driver.display_name+'</li>'+
                                '<li><i class="fa fa-phone" aria-hidden="true"></i>: '+driver.contact_number+'</li>'+
                                '<li><i class="fa fa-taxi" aria-hidden="true"></i>: '+service_name+'</li>'+
                                '<li><i class="fa fa-clock" aria-hidden="true"></i>: '+last_location_update_at+'</li>'+
                                '<li><a href="'+driver_view+'"><i class="fa fa-eye" aria-hidden="true"></i> {{ __("message.view_form_title",[ "form" => __("message.driver") ]) }}</a></li>'+
                                '</ul></div>';
                                infowindow.setContent(contentString);
                                // infowindow.setContent(locations[i].display_name);
                                infowindow.open(map, marker);
                            }
                        })(marker, i));
                        markers[locations[i].id] = marker;
                    }
                }
            }

            function driverDetail(driver_id) {
                url = "{{ route('driverdetail',[ 'id' =>'']) }}"+driver_id;
                var driver_data;
                $.ajax({
                    type: 'get',
                    url: url,
                    async: false,
                    success: function(res) {
                        driver_data = res.data;
                    }
                });
                return driver_data;
            }
            function driverList() {
                var url = "{{ route('driver_list.map') }}";
                $.ajax({
                    type: 'get',
                    url: url,
                    success: function(res) {
                        if(res.data.length > 0) {
                            changeMarkerPositions(res.data)
                        }
                    }
                });
            }

            if(window.google || window.google.maps) {
                initialize();
                $('#maplegend').removeClass('d-none')
                // console.log('1.initial');
            }
        });
    </script>
@endsection
</x-master-layout>