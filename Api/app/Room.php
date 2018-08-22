<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

class Room extends Model
{
    protected $fillable = [
        'name',
        'channel',
        'chatkit_room_id',
    ];

    protected $casts = [
        'channel' => 'boolean',
        'chatkit_room_id' => 'integer',
    ];

    public function getNameAttribute(): string
    {
        $isChannel = (bool) $this->attributes['channel'];

        if ($isChannel === true) {
            return $this->attributes['name'];
        }

        return $this->users()
            ->where('user_id', '!=', request()->user()->id)
            ->get()
            ->implode('name', ', ');
    }

    public function users()
    {
        return $this->belongsToMany(User::class);
    }
}
