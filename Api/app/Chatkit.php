<?php

namespace App;

use Chatkit\Chatkit as PusherChatkit;

class Chatkit extends PusherChatkit
{
    public function getUserJoinableRooms(array $options)
    {
        return $this->getUserRooms([
            'joinable' => true,
            'user_id' => $options['user_id'] ?? null
        ]);
    }

    public function rooms($include_private = false)
    {
        $ch = $this->createCurl(
            $this->api_settings,
            '/rooms/',
            $this->getServerToken(),
            'GET',
            [],
            ['include_private' => $include_private]
        );

        return $this->execCurl($ch);
    }
}
