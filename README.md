# chatapp-swift-chatkit-beams

Create a chatroom with Swift, Pusher Chatkit, and Pusher Beams

### View tutorial

- [Part 1](https://pusher.com/tutorials/ios-messenger-push-notifications-part-1)
- [Part 2](https://pusher.com/tutorials/ios-messenger-push-notifications-part-2)

## Getting Started

Clone the repository.

### API

- `cd` to the `Api` directory.
- Copy the `.env.example` to `.env`.
- Update the database, Chatkit and Beams credentials.
- Run `composer install`.
- Run `php artisan migrate`.
- Run `php artisan passport:install`.
- Run `php artisan serve` to start the server.

### APP

- Open the `Convey.xcworkspace` file in Xcode.
- Update the keys in `AppConstants.swift`.
- Update the general settings for the application.
- Run the application.

### Prerequisites

You need the following installed:

- [Xcode](https://developer.apple.com/xcode)
- [Composer](https://getcomposer.org)

## Built With

- [Laravel](https://laravel.com/) - PHP framework
- [Xcode](https://developer.apple.com/xcode)
- [Swift](https://developer.apple.com/swift)
