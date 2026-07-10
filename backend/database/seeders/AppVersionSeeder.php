<?php

declare(strict_types=1);

namespace Database\Seeders;

use App\Models\Setting;
use Illuminate\Database\Seeder;

class AppVersionSeeder extends Seeder
{
    /**
     * Seed default app version settings for customer and driver mobile apps.
     */
    public function run(): void
    {
        // Customer app versions
        Setting::setValue('customer_app_min_version', '1.0.0', 'string', 'app_versions');
        Setting::setValue('customer_app_latest_version', '1.0.0', 'string', 'app_versions');
        Setting::setValue('customer_app_play_store_url',
            'https://play.google.com/store/apps/details?id=com.hrsystem.customer',
            'string',
            'app_versions'
        );
        Setting::setValue('customer_app_app_store_url',
            'https://apps.apple.com/app/idXXXXXXXXX',
            'string',
            'app_versions'
        );

        // Driver app versions
        Setting::setValue('driver_app_min_version', '1.0.0', 'string', 'app_versions');
        Setting::setValue('driver_app_latest_version', '1.0.0', 'string', 'app_versions');
        Setting::setValue('driver_app_play_store_url',
            'https://play.google.com/store/apps/details?id=com.hrsystem.driver',
            'string',
            'app_versions'
        );
        Setting::setValue('driver_app_app_store_url',
            'https://apps.apple.com/app/idXXXXXXXXX',
            'string',
            'app_versions'
        );
    }
}
