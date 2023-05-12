<?php

namespace App\Notifications;

use Illuminate\Bus\Queueable;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Notifications\Messages\MailMessage;
use Illuminate\Notifications\Notification;
use App\Models\AppSetting;
use NotificationChannels\OneSignal\OneSignalChannel;
use NotificationChannels\OneSignal\OneSignalMessage;
use Illuminate\Support\Facades\Log;
use Benwilkins\FCM\FcmMessage;
use Berkayk\OneSignal\OneSignalClient;

class CommonNotification extends Notification
{
    use Queueable;
    public $type, $data, $subject, $notification_message;
    /**
     * Create a new notification instance.
     *
     * @return void
     */
    public function __construct($type, $data)
    {
        $this->type = $type;
        $this->data = $data;
        $this->subject = str_replace("_"," ",ucfirst($this->data['subject']));
        $this->notification_message = $this->data['message'] != '' ? $this->data['message'] : __('message.default_notification_body');
    }

    /**
     * Get the notification's delivery channels.
     *
     * @param  mixed  $notifiable
     * @return array
     */
    public function via($notifiable)
    {
        $notifications = []; 

        if( $notifiable->user_type == 'driver' && env('ONESIGNAL_DRIVER_APP_ID') && env('ONESIGNAL_DRIVER_REST_API_KEY')) 
        {
                $heading = [
                    'en' => $this->subject,
                ];
        
                $content = [
                    'en' => strip_tags($this->notification_message),
                ];
                
                $parameters = [
                    'api_key' => env('ONESIGNAL_DRIVER_REST_API_KEY'),
                    'app_id' => env('ONESIGNAL_DRIVER_APP_ID'),
                    'include_player_ids' => [$notifiable->player_id],
                    'headings' => $heading,
                    'contents' => $content,
                    'data'  => [
                        'id' => $this->data['id'],
                        'type' => $this->data['type'],
                    ]
                ];

                // Log::info('driver-notifiable-'.$notifiable);
                $onesignal_client = new OneSignalClient(env('ONESIGNAL_DRIVER_APP_ID'), env('ONESIGNAL_DRIVER_REST_API_KEY') , null );
                $onesignal_client->sendNotificationCustom($parameters);
        } else {
            array_push($notifications, OneSignalChannel::class);
        }

        // Log::info('notifiable-'.$notifiable);
        if( env('FIREBASE_SERVER_KEY') && $notifiable->user_type == 'rider') {
            array_push($notifications, 'fcm');
        }
        return $notifications;
    }

    public function toOneSignal($notifiable)
    {
        $msg = strip_tags($this->notification_message);
        if (!isset($msg) && $msg == ''){
            $msg = __('message.default_notification_body');
        }

        $type = 'new_ride_requested';
        if (isset($this->data['type']) && $this->data['type'] !== ''){
            $type = $this->data['type'];
        }

        // Log::info('onesignal notifiable'.json_encode($this->data));
        return OneSignalMessage::create()
            ->setSubject($this->subject)
            ->setBody($msg) 
            ->setData('id',$this->data['id'])
            ->setData('type',$type);
    }

    public function toFcm($notifiable)
    {
        $message = new FcmMessage();
        $msg = strip_tags($this->notification_message);
        if (!isset($msg) && $msg == ''){
            $msg = __('message.default_notification_body');
        }
        $notification = [
            'body' => $msg,
            'title' => $this->subject,
        ];
        $data = [
            'click_action' => "FLUTTER_NOTIFICATION_CLICK",
            'sound' => 'default',
            'status' => 'done',
            'id' => $this->data['id'],
            'type' => $this->data['type'],
            'message' => $notification,
        ];
        // Log::info('fcm notifiable'.json_encode($notifiable));
        $message->content($notification)->data($data)->priority(FcmMessage::PRIORITY_HIGH);

        return $message;
    }

    /**
     * Get the mail representation of the notification.
     *
     * @param  mixed  $notifiable
     * @return \Illuminate\Notifications\Messages\MailMessage
     */
    public function toMail($notifiable)
    {
        return (new MailMessage)
                    ->line('The introduction to the notification.')
                    ->action('Notification Action', url('/'))
                    ->line('Thank you for using our application!');
    }

    /**
     * Get the array representation of the notification.
     *
     * @param  mixed  $notifiable
     * @return array
     */
    public function toArray($notifiable)
    {
        return [
            //
        ];
    }
}
