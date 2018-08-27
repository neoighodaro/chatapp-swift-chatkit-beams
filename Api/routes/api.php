<?php

Route::group(['middleware' => 'auth:api'], function () {
    Route::post('/chatkit/token', 'ChatkitController@getToken');
    Route::post('/rooms/sent_message', 'ChatkitController@sentMessage');
    Route::get('/rooms/joinable', 'ChatkitController@getJoinableRooms');
    Route::post('/rooms/add', 'ChatkitController@addToRoom');
    Route::get('/rooms', 'ChatkitController@getJoinedRooms');
    Route::post('/rooms', 'ChatkitController@createRoom');
});

Route::post('/users/signup', 'UserController@create');

Route::get('/setup', function (App\Chatkit $chatkit) {
    $users = collect([]);

    foreach (['Neo', 'Lena'] as $name) {
        $email = strtolower("{$name}@convey.test");
        $chatkit_id = str_slug($email, '_');

        $resp = $chatkit->createUser(['id' => $chatkit_id, 'name' => $name]);

        if ($resp['status'] === 201) {
            $users->push(
                App\User::create([
                    'name' => $name,
                    'email' => $email,
                    'password' => 'secret',
                    'chatkit_id' => $chatkit_id,
                ])
            );
        }
    }

    $resp = $chatkit->createRoom([
        'creator_id' => $users->first()->chatkit_id,
        'name' => 'General',
        'private' => false,
        'user_ids' => $users->pluck('chatkit_id')->toArray()
    ]);

    if ($resp['status'] === 201) {
        $room = App\Room::firstOrCreate(['name' => 'General'], [
            'channel' => true,
            'chatkit_room_id' => $resp['body']['id'],
        ]);

        foreach ($users as $user) {
            if ($room->users()->whereUserId($user->id)->count() === 0) {
                $room->users()->save($user);
            }
        }
    }

    return [
        'status' => 'complete',
        'rooms' => $resp,
        'users' => $users->toArray(),
    ];
});
