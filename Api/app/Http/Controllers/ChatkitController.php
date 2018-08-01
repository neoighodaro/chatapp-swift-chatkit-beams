<?php

namespace App\Http\Controllers;

use App\Chatkit;

class ChatkitController extends Controller
{
    /**
     * Checks a users login credentials.
     *
     * @param  \App\Chatkit $chatkit
     * @return \Illuminate\Http\JsonResponse
     */
    public function getToken(Chatkit $chatkit)
    {
        $user = auth()->user();

        $response = $chatkit->authenticate(['user_id' => $user->chatkit_id]);

        $data = array_merge($response['body'], [
            'user' => $user->toArray(),
            'user_id' => $user->id,
            'chatkit_id' => $user->chatkit_id
        ]);

        return response()->json($data, $response['status']);
    }

    public function getJoinableRooms(Chatkit $chatkit)
    {
        $response = $chatkit->rooms(false);

        info((array) $response['body']);

        return response()->json((array) $response['body']);
    }
}
