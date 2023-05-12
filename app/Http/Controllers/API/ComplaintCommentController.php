<?php

namespace App\Http\Controllers\API;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\ComplaintComment;
use App\Http\Resources\ComplaintCommentResource;
use App\Notifications\RideNotification;
use App\Notifications\CommonNotification;
use App\Models\User;

class ComplaintCommentController extends Controller
{
    public function getList(Request $request)
    {
        $comment = ComplaintComment::query();

        $comment->when(request('complaint_id'), function ($q) {
            return $q->where('complaint_id', request('complaint_id'));
        });
        
        if( $request->has('status') && isset($request->status) ) {
            $comment = $comment->where('status',request('status'));
        }
        
        $per_page = config('constant.PER_PAGE_LIMIT');
        if( $request->has('per_page') && !empty($request->per_page)){
            if(is_numeric($request->per_page))
            {
                $per_page = $request->per_page;
            }
            if($request->per_page == -1 ){
                $per_page = $comment->count();
            }
        }

        $comment = $comment->orderBy('id', 'desc')->paginate($per_page);
        $items = ComplaintCommentResource::collection($comment);

        $current_user = auth()->user();
        if(count($current_user->unreadNotifications) > 0 ) {
            $current_user->unreadNotifications->where('data.complaint_id',request('complaint_id'))->markAsRead();
        }
        $response = [
            'pagination' => json_pagination_response($items),
            'data' => $items,
        ];
        
        return json_custom_response($response);
    }
}