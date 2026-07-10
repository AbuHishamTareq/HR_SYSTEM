<?php

declare(strict_types=1);

use App\Http\Controllers\Api\V1\AppVersionController;
use Illuminate\Support\Facades\Route;

// Public routes (no auth required)
Route::get('app-version', AppVersionController::class);

Route::prefix('auth')->group(base_path('routes/api/v1/auth.php'));
Route::middleware('auth:sanctum')->group(base_path('routes/api/v1/users.php'));
