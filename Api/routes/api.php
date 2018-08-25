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
