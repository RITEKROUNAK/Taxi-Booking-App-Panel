<?php

namespace App\Http\Resources;

use Illuminate\Http\Resources\Json\JsonResource;

class ComplaintCommentResource extends JsonResource
{
    /**
     * Transform the resource into an array.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return array|\Illuminate\Contracts\Support\Arrayable|\JsonSerializable
     */
    public function toArray($request)
    {
        return [
            'id'            => $this->id,
            'user_id'       => $this->user_id,
            'user_name'   => optional($this->user)->display_name,
            'user_profile_image' => getSingleMedia(optional($this->user), 'profile_image',null),

            'complaint_id'  => $this->complaint_id,
            'added_by'      => $this->added_by,
            'status'        => $this->status,
            'comment'       => $this->comment,
            'created_at'    => $this->created_at,
            'updated_at'    => $this->updated_at,
        ];
    }
}