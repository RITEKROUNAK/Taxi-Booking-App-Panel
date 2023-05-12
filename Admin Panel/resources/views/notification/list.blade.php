<div class="p-3 card-header-border">
    <h6 class="text-center">
        {{ __('message.notification') }}   <small class="badge badge-light float-right pt-1 notification_count notification_tag"> {{ $all_unread_count }}</small>
    </h6>
</div>
<div class="px-2 py-2">
    <h6 class="text-sm text-muted m-0"><span class="notification_count">{{  __('message.you_have_unread_notification',['number' => $all_unread_count ]) }}</span>
        @if($all_unread_count > 0 )
            <a href="#" data-type="markas_read" class="notifyList float-right" ><span>{{ __('message.mark_all_as_read') }}</span></a>
        @endif
    </h6>
</div>

@if(isset($notifications) && count($notifications) > 0)
    <div class="notification-height">
        @foreach($notifications->sortByDesc('created_at')->take(5) as  $notification)
            @php
                if( $notification->data['type'] == 'complaintcomment' ) {
                    $notification_id = $notification->data['complaint_id'];
                    $route = route('complaint.show', $notification_id);
                } else {
                    $notification_id = $notification->data['id'];
                    $route = route('riderequest.show', $notification_id );
                }
            @endphp
            <a href="{{ $route }}" class="sub-card {{ $notification->read_at ? '':'notify-list-bg'}}">
                <div class="media align-items-center">
                    <div class="media-body ml-3">
                        <h6 class="mb-0">#{{ $notification_id }} {{ __('message.'.$notification->data['type'])  }}</h6>
                        <small class="float-right font-size-12">{{ timeAgoFormate($notification->created_at)  }}</small>
                        <p class="mb-0">{{ isset($notification->data['message']) ? $notification->data['message'] : __('message.booked') }}</p>
                    </div>
                </div>
            </a>
        @endforeach
    </div>
    <a href="{{ route('notification.index') }}" class="dropdown-item text-center text-primary font-weight-bold py-3">{{ __('message.view_all') }}</a>
@else
    <a href="#" class="sub-card">
        <div class="media align-items-center">
            <div class="media-body ml-3">
                <h6 class="mb-0">{{ __('message.no_notification') }}</h6>
                <small class="float-right font-size-12"></small>
                <p class="mb-0"></p>
            </div>
        </div>
    </a>
@endif
<script>
    $('.notifyList').on('click',function() {
        notificationList($(this).attr('data-type'));
    });

    $(document).on('click','.notification_data',function(event) {
        event.stopPropagation();
    })

    function notificationList(type='') {
        var url = "{{ route('notification.list') }}";
        $.ajax({
            type: 'get',
            url: url,
            data: {'type':type},
            success: function(res) {

                $('.notification_data').html(res.data);
                getNotificationCounts();
                if(res.type == "markas_read") {
                    notificationList();
                }
                $('.notify_count').removeClass('notification_tag').text('');
            }
        });
    }

    function getNotificationCounts() {
        var url = "{{ route('notification.counts') }}";
        $.ajax({
            type: 'get',
            url: url,
            success: function(res) {
                if(res.counts > 0) {
                    $('.notify_count').addClass('notification_tag').text(res.counts);
                    setNotification(res.counts);
                    $('.notification_list span.dots').addClass('d-none')
                    $('.notify_count').removeClass('d-none')
                } else {
                    $('.notify_count').addClass('d-none')
                    $('.notification_list span.dots').removeClass('d-none')
                }

                if(res.counts <= 0 && res.unread_total_count > 0) {
                    $('.notification_list span.dots').removeClass('d-none')
                } else {
                    $('.notification_list span.dots').addClass('d-none')
                }
            }
        });
    }
</script>