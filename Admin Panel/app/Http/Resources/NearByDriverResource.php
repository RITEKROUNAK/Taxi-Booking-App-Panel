<?php

namespace App\Http\Resources;

use Illuminate\Http\Resources\Json\JsonResource;

class NearByDriverResource extends JsonResource
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
            'id'                => $this->id,
            'first_name'        => $this->first_name,
            'last_name'         => $this->last_name,
            'display_name'      => $this->display_name,
            'status'            => $this->status,
            'latitude'          => $this->latitude,
            'longitude'         => $this->longitude,
            'is_online'         => $this->is_online,
            'is_available'      => $this->is_available,
            'rating'            => count($this->driverRating) > 0 ? (float) number_format(max($this->driverRating->avg('rating'),0), 2) : 0,
            'last_location_update_at' => $this->last_location_update_at,
        ];
    }
}
