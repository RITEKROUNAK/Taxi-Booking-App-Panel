<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\ComplaintComment;
use App\Models\User;
use App\Notifications\RideNotification;

class ComplaintCommentController extends Controller
{
    /**
     * Store a newly created resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return \Illuminate\Http\Response
     */
    public function store(Request $request)
    {
        $request['user_id'] = auth()->id();
        $request['added_by'] = auth()->user()->user_type;
        
        $comment = ComplaintComment::create($request->all());

        $message = __('message.save_form',['form' => __('message.comment')]);
        
        $admin = User::admin();
        
        $complaint_by = optional($comment->complaint)->complaint_by;
        
        if( $complaint_by == 'rider' ) {
            $user = User::where('id',$comment->complaint->rider_id)->first();
        }

        if( $complaint_by == 'driver' ) {
            $user = User::where('id',$comment->complaint->driver_id)->first();
        }
        
        $notification_data = [
            'complaint_id'  => $comment->complaint_id,
            'type'      => 'complaintcomment',
            'subject'   => __('message.complaintcomments.title', [ 'id' => $comment->complaint_id ]),
            'message'   => __('message.complaintcomments.message', [ 'name' => __('message.'.$comment->added_by)]),
            'created_by'=> $comment->user_id,
        ];
        
        if( $comment->added_by == 'admin' ) {
            $user->notify(new RideNotification($notification_data));
        } else {
            $admin->notify(new RideNotification($notification_data));
        }

        if(request()->is('api/*')){
            return json_message_response( $message );
        }

        return redirect()->route('complaint.show',$comment->complaint_id)->withSuccess($message);
    }

    /**
     * Show the form for editing the specified resource.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function edit($id)
    {
        $pageTitle = __('message.update_form_title',[ 'form' => __('message.comment')]);
        $data = ComplaintComment::findOrFail($id);
        
        return view('sos.form', compact('data', 'pageTitle', 'id'));
    }

    /**
     * Update the specified resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function update(Request $request, $id)
    {
        $comment = ComplaintComment::findOrFail($id);

        // ComplaintComment data...
        $comment->fill($request->all())->update();

        $message = __('message.update_form',['form' => __('message.comment')]);

        if(request()->is('api/*')){
            return json_message_response( $message );
        }

        if(auth()->check()){
            return redirect()->route('sos.index')->withSuccess($message);
        }
        return redirect()->back()->withSuccess($message);
    }

    /**
     * Remove the specified resource from storage.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function destroy($id)
    {
        if(env('APP_DEMO')){
            $message = __('message.demo_permission_denied');
            if(request()->ajax()) {
                return response()->json(['status' => true, 'message' => $message ]);
            }
            return redirect()->route('sos.index')->withErrors($message);
        }
        $comment = ComplaintComment::find($id);
        $status = 'errors';
        $message = __('message.not_found_entry', ['name' => __('message.comment')]);

        if($comment != '') {
            $comment->delete();
            $status = 'success';
            $message = __('message.delete_form', ['form' => __('message.comment')]);
        }
        
        if(request()->is('api/*')){
            return json_message_response( $message );
        }

        if(request()->ajax()) {
            return response()->json(['status' => true, 'message' => $message ]);
        }

        return redirect()->back()->with($status,$message);
    }
}
