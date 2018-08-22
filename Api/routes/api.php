<?php


/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
|
| Here is where you can register API routes for your application. These
| routes are loaded by the RouteServiceProvider within a group which
| is assigned the "api" middleware group. Enjoy building your API!
|
*/

Route::group(['middleware' => 'auth:api'], function () {
    Route::post('/chatkit/token', 'ChatkitController@getToken');
    Route::get('/rooms', 'ChatkitController@getJoinableRooms');
    Route::post('/rooms', 'ChatkitController@createRoom');

    /*
    |--------------------------------------------------------------------------
    | API Routes
    |--------------------------------------------------------------------------
    |
    | Here is where you can register API routes for your application. These
    | routes are loaded by the RouteServiceProvider within a group which
    | is assigned the "api" middleware group. Enjoy building your API!
    |
    */

    Route::group(['middleware' => 'auth:api'], function () {
        Route::post('/chatkit/token', 'ChatkitController@getToken');
        Route::get('/rooms', 'ChatkitController@getJoinedRooms');
        Route::get('/rooms/joinable', 'ChatkitController@getJoinableRooms');
        Route::post('/rooms', 'ChatkitController@createRoom');
        Route::post('/rooms/add', 'ChatkitController@addToRoom');
    });

    Route::post('/users/signup', 'UserController@create');
});

Route::post('/users/signup', 'UserController@create');
