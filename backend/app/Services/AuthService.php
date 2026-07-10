<?php

declare(strict_types=1);

namespace App\Services;

use App\DTOs\Auth\LoginDto;
use App\DTOs\Auth\RegisterDto;
use App\Models\Role;
use App\Models\User;
use App\Repositories\UserRepository;
use Illuminate\Support\Facades\Hash;

class AuthService extends BaseService
{
    public function __construct(
        private readonly UserRepository $userRepository,
    ) {}

    public function register(RegisterDto $dto): User
    {
        $user = $this->userRepository->create([
            'name' => $dto->name,
            'email' => $dto->email,
            'password' => $dto->password,
            'phone' => $dto->phone,
        ]);

        $customerRole = Role::where('slug', 'customer')->first();
        if ($customerRole) {
            $user->assignRole($customerRole);
        }

        return $user;
    }

    public function login(LoginDto $dto): ?User
    {
        $user = $this->userRepository->findByEmail($dto->email);

        if (! $user || ! Hash::check($dto->password, $user->password)) {
            return null;
        }

        if (! $user->is_active) {
            return null;
        }

        return $user;
    }

    public function createToken(User $user, string $device = 'web'): string
    {
        $user->tokens()->where('name', $device)->delete();

        return $user->createToken($device)->plainTextToken;
    }

    public function revokeTokens(User $user): void
    {
        $user->tokens()->delete();
    }
}
