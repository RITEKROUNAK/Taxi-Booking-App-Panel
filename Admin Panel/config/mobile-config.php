<?php

return [
    'CURRENCY' => [
        // 'NAME' => '',
        'CODE' => '',
        // 'SYMBOL' => '',
        'POSITION' => ''
    ],

    'ONESIGNAL' => [
        'APP_ID' => env('ONESIGNAL_APP_ID'),
        'REST_API_KEY' => env('ONESIGNAL_REST_API_KEY'),
        'DRIVER_APP_ID' => env('ONESIGNAL_DRIVER_APP_ID'),
        'DRIVER_REST_API_KEY' => env('ONESIGNAL_DRIVER_REST_API_KEY'),
    ],

    'DISTANCE' => [
        'RADIUS' => ''
    ],

    'RIDE' => [
        'FOR_OTHER' => ''
    ],

    'FIREBASE' => [
        'SERVER_KEY' => env('FIREBASE_SERVER_KEY'),
    ],
];