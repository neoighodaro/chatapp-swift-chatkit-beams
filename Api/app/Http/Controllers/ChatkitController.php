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
        $response = $chatkit->authenticate([
            'user_id' => auth()->user()->chatkit_id
        ]);

        return response()->json($response['body'], $response['status']);
    }
}
