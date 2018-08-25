<?php

namespace App\Providers;

use App\Chatkit;
use Illuminate\Support\ServiceProvider;
use Pusher\PushNotifications\PushNotifications;

class AppServiceProvider extends ServiceProvider
{
    /**
     * Bootstrap any application services.
     *
     * @return void
     */
    public function boot()
    {
    }

    /**
     * Register any application services.
     *
     * @return void
     */
    public function register()
    {
        $this->app->bind(Chatkit::class, function () {
            return new Chatkit([
                'key' => config('services.chatkit.secret'),
                'instance_locator' => config('services.chatkit.instanceLocator'),
            ]);
        });

        $this->app->singleton('push_notifications', function () {
            return new PushNotifications([
                'instanceId' => env('PUSHER_PN_INSTANCE_ID'),
                'secretKey' => env('PUSHER_PN_SECRET_KEY'),
            ]);
        });
    }
}
