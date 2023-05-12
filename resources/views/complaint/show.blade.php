<x-master-layout>
<div class="container-fluid">
    <div class="row">            
        <div class="col-lg-12">
            <div class="card card-block card-stretch">
                <div class="card-body p-0">
                    <div class="d-flex justify-content-between align-items-center p-3">
                        <h5 class="font-weight-bold">{{ $pageTitle }}</h5>
                        <a href="{{ route('complaint.index') }}" class="float-right btn btn-sm btn-primary"><i class="fa fa-angle-double-left"></i> {{ __('message.back') }}</a>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div class="row">
        <div class="col-xl-8 content">
            <div class="card card-block">
                @php
                    $user = auth()->user();
                @endphp
                @if( count($data->complaintcomment) > 0  )
                    <div class="card-body chat-body bg-body">
                        @foreach( $data->complaintcomment as $comment )
                            @php
                                if( $comment->added_by == $user->user_type ) {
                                    $current_user = 'mm-current-user';
                                    $message = 'justify-content-end';
                                } else {
                                    $current_user = 'mm-other-user';
                                    $message = 'justify-content-start';
                                }
                            @endphp
                            
                            <div class="chat-day-title d-none">
                                <span class="main-title">Dec 1,2022</span>
                            </div>
                            <div class="mm-message-body {{ $current_user }}">
                                <div class="chat-profile">
                                    <img src="{{ getSingleMedia(optional($comment->user), 'profile_image',null) }}" alt="chat-user" class="avatar-40 rounded-pill" loading="lazy">
                                </div>
                                <div class="mm-chat-text">
                                    <small class="mm-chating p-0">{{  optional($comment->user)->display_name }}, {{ date('H:i', strtotime($comment->created_at)) }}</small>
                                    <div class="d-flex align-items-center {{ $message }}">
                                        <div class="mm-chating-content d-flex align-items-center ">
                                            <p class="mr-2 mb-0">{{ $comment->comment }}</p>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        @endforeach
                    </div>
                @endif
                <div class="card-footer px-3 py-3">
                    {{ Form::open(['route' => 'complaintcomment.store', 'method' => 'POST', 'data-toggle'=>'validator', 'id'=>'commentForm', 'button-loader'=> 'true', 'data-ajax' => 'true', 'data-submit-reset' => 'true' ]) }}
                        {{ Form::hidden('id', null) }}
                        {{ Form::hidden('complaint_id', $data->id) }}
                        <div class="input-group mb-3">
                            {{ Form::text('comment',old('comment'),[ 'placeholder' => __('message.enter_name',[ 'name' => 'here...' ]), 'class' =>'form-control', 'required']) }}
                            <div class="input-group-append">
                                <button type="submit" class="btn btn-outline-primary" type="button"><i class="fas fa-paper-plane"></i></button>
                            </div>
                        </div>
                    {{ Form::close() }}
                </div>
            </div>
        </div>
        <div class="col-md-4 pl-0 sidebar">
            <div class="card">
                <div class="card-header d-flex justify-content-between">
                    <div class="header-title d-flex">
                        @php
                            $status = 'warning';
                            switch ($data->status) {
                                case 'investigation':
                                    $status = 'primary';
                                    break;
                                case 'resolved':
                                    $status = 'success';
                                    break;
                                default:
                                    break;
                            }
                        @endphp
                        <h4 class="card-title">
                            <span class="pr-2">{{ __('message.detail_form_title', ['form' => __('message.complaint')]) }}</span>
                            <span class="badge bg-{{ $status }}" data-toggle="tooltip" title="" data-original-title="{{ __('message.status') }}">{{ __('message.'.$data->status) }}</span>
                        </h4>
                    </div>
                </div>
               
                <div class="table-responsive">
                    <table class="table align-items-center border-0">
                        <tbody>
                            <tr>
                                <td class="t-head">{{ __('message.complaint_id') }}</td>
                                <td class="t-head">
                                    #{{ $data->id }} | 
                                    <span data-toggle="tooltip" data-original-title="{{ date('d M Y', strtotime($data->created_at)) }}">{{ timeAgoFormate($data->created_at) }}</span><br>
                                </td>
                            </tr>
                            <tr>
                                <td class="t-head"> {{ __('message.complaint_by') }}</td>

                                @php
                                    if($data->complaint_by == 'rider'){
                                        $user_name = optional($data->rider)->display_name;
                                        $email = optional($data->rider)->email;
                                    }
                                    if($data->complaint_by == 'driver') {
                                        $user_name = optional($data->driver)->display_name;
                                        $email = optional($data->driver)->email;
                                    }
                                @endphp
                                <td class="t-head">{{ $user_name ?? '-' }} </td>
                            </tr>
                            <tr>
                                <td class="t-head"> Email Address</td>
                                <td class="t-head">{{ $email ?? '-' }}</td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>          
    </div>
</div>
</x-master-layout>