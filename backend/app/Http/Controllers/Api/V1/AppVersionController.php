<?php

declare(strict_types=1);

namespace App\Http\Controllers\Api\V1;

use App\Http\Controllers\Controller;
use App\Models\Setting;

class AppVersionController extends Controller
{
    /**
     * Return minimum and latest version requirements for both mobile apps,
     * along with store URLs for each platform.
     *
     * GET /api/v1/app-version
     */
    public function __invoke()
    {
        return response()->json([
            'success' => true,
            'data' => [
                'customer_app' => [
                    'min_version' => Setting::getValue('customer_app_min_version', '1.0.0'),
                    'latest_version' => Setting::getValue('customer_app_latest_version', '1.0.0'),
                    'play_store_url' => Setting::getValue('customer_app_play_store_url',
                        'https://play.google.com/store/apps/details?id=com.hrsystem.customer'),
                    'app_store_url' => Setting::getValue('customer_app_app_store_url',
                        'https://apps.apple.com/app/idXXXXXXXXX'),
                ],
                'driver_app' => [
                    'min_version' => Setting::getValue('driver_app_min_version', '1.0.0'),
                    'latest_version' => Setting::getValue('driver_app_latest_version', '1.0.0'),
                    'play_store_url' => Setting::getValue('driver_app_play_store_url',
                        'https://play.google.com/store/apps/details?id=com.hrsystem.driver'),
                    'app_store_url' => Setting::getValue('driver_app_app_store_url',
                        'https://apps.apple.com/app/idXXXXXXXXX'),
                ],
            ],
        ]);
    }
}
