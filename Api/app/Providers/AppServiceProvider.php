<?php

namespace App\Providers;

use App\Chatkit;
use Illuminate\Support\ServiceProvider;

class AppServiceProvider extends ServiceProvider
{
    /**
     * Bootstrap any application services.
     *
     * @return void
     */
    public function boot()
    {
        //
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
    }
}
