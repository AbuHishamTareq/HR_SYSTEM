<?php

declare(strict_types=1);

namespace App\Http\Controllers\Api\V1;

use App\DTOs\Auth\LoginDto;
use App\DTOs\Auth\RegisterDto;
use App\Http\Controllers\Controller;
use App\Http\Requests\Api\V1\LoginRequest;
use App\Http\Requests\Api\V1\RegisterRequest;
use App\Http\Resources\Api\V1\UserResource;
use App\Services\AuthService;
use App\Traits\ApiResponse;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class AuthController extends Controller
{
    use ApiResponse;

    public function __construct(
        private readonly AuthService $authService,
    ) {}

    public function register(RegisterRequest $request): JsonResponse
    {
        $dto = RegisterDto::fromRequest($request->validated());
        $user = $this->authService->register($dto);
        $token = $this->authService->createToken($user);

        $user->load('roles.permissions');

        return $this->created([
            'user' => new UserResource($user),
            'token' => $token,
        ], 'Registration successful');
    }

    public function login(LoginRequest $request): JsonResponse
    {
        $dto = LoginDto::fromRequest($request->validated());
        $user = $this->authService->login($dto);

        if (!$user) {
            return $this->unauthorized('Invalid credentials or account inactive');
        }

        $token = $this->authService->createToken($user);

        $user->load('roles.permissions');

        return $this->success([
            'user' => new UserResource($user),
            'token' => $token,
        ], 'Login successful');
    }

    public function me(Request $request): JsonResponse
    {
        $user = $request->user()->load('roles.permissions');

        return $this->success(
            new UserResource($user)
        );
    }

    public function logout(Request $request): JsonResponse
    {
        $this->authService->revokeTokens($request->user());

        return $this->success(null, 'Logged out successfully');
    }
}
