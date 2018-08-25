<?php

namespace App\Http\Controllers;

use App\Chatkit;
use App\User;
use Illuminate\Http\Request;
use App\Room;

class ChatkitController extends Controller
{
    /**
     * @var \App\Chatkit
     */
    protected $chatkit;

    /**
     * Class constructor
     *
     * @param Chatkit $chatkit
     */
    public function __construct(Chatkit $chatkit)
    {
        $this->chatkit = $chatkit;
    }

    /**
     * Checks a users login credentials.
     *
     * @return \Illuminate\Http\JsonResponse
     */
    public function getToken()
    {
        $user = auth()->user();

        $response = (array) $this->chatkit->authenticate([
            'user_id' => $user->chatkit_id
        ]);

        $data = array_merge($response['body'], [
            'user' => $user->toArray(),
            'user_id' => $user->id,
            'chatkit_id' => $user->chatkit_id
        ]);

        return response()->json($data, $response['status']);
    }

    /**
     * Get the joined rooms for the user.
     *
     * @param \Illuminate\Http\Request $request
     * @return \Illuminate\Http\JsonResponse
     */
    public function getJoinedRooms(Request $request)
    {
        $rooms = $request->user()
            ->rooms()
            ->without('users')
            ->orderBy('channel', 'ASC')
            ->get()
            ->toArray();

        return response()->json($rooms);
    }

    /**
     * Get the joinable rooms list.
     *
     * @return \Illuminate\Http\JsonResponse
     */
    public function getJoinableRooms()
    {
        $rooms = (array) $this->chatkit->rooms()['body'] ?? [];

        return response()->json($rooms);
    }

    /**
     * Create a new room for two users.
     *
     * @param \Illuminate\Http\Request $request
     * @return \Illuminate\Http\JsonResponse
     */
    public function createRoom(Request $request)
    {
        $me = $request->user();

        $data = $request->validate([
            'email' => "required|exists:users|not_in:{$me->email}"
        ]);

        $friend = User::whereEmail($data['email'])->first();

        $room_name = str_random();

        $chatkitRoom = $this->chatkit->createRoom([
            'private' => true,
            'name' => $room_name,
            'creator_id' => $request->user()->chatkit_id,
            'user_ids' => [$me->chatkit_id, $friend->chatkit_id]
        ]);

        $room = Room::create([
            'channel' => false,
            'name' => $room_name,
            'chatkit_room_id' => $chatkitRoom['body']['id']
        ]);

        $room->users()->saveMany([$me, $friend]);

        return response()->json(
            array_merge($room->toArray(), ['name' => $friend->name])
        );
    }

    /**
     * Adds a user to a room.
     *
     * @param \Illuminate\Http\Request $request
     * @return \Illuminate\Http\JsonResponse
     */
    public function addToRoom(Request $request)
    {
        $me = $request->user();

        $data = $request->validate([
            'name' => 'required',
            'room_id' => 'required',
        ]);

        $response = $this->chatkit->addUsersToRoom(
            $data['room_id'],
            [$me->chatkit_id]
        );

        if ($response['status'] == 204) {
            $room = Room::firstOrCreate(
                ['chatkit_room_id' => $data['room_id']],
                ['channel' => true, 'name' => $data['name']]
            );

            if ($room->users()->whereUserId($me->id)->count() === 0) {
                $room->users()->save($me);
            }
        }

        return response()->json([], $response['status']);
    }

    /**
     * Send push notification when a message is sent.
     *
     * @param \Illuminate\Http\Request $request
     * @return \Illuminate\Http\JsonResponse
     */
    public function sentMessage(Request $request)
    {
        $data = $request->validate([
            'message' => 'required|string',
            'chatkit_room_id' => 'required|exists:rooms',
        ]);

        $interest = $data['chatkit_room_id'];
        $title = "New message from {$request->user()->name}";

        $response = (array) app('push_notifications')->publish([$interest], [
            'apns' => [
                'aps' => [
                    'alert' => [
                        'title' => $title,
                        'body' => $message,
                    ],
                    'mutable-content' => 0,
                    'category' => 'pusher',
                    'sound' => 'default'
                ],
                'data' => [
                    'room' => Room::find($data['chatkit_room_id'])
                ],
            ],
        ]);

        return response()->json($response);
    }
}
