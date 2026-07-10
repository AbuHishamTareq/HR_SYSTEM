<?php

declare(strict_types=1);

namespace App\Services;

use App\Models\User;
use App\Repositories\UserRepository;
use Illuminate\Pagination\LengthAwarePaginator;

class UserService extends BaseService
{
    public function __construct(
        private readonly UserRepository $userRepository,
    ) {}

    public function list(): LengthAwarePaginator
    {
        return $this->userRepository->paginate();
    }

    public function find(int|string $id): ?User
    {
        return $this->userRepository->findById($id);
    }

    public function update(User|int|string $user, array $data): User
    {
        return $this->userRepository->update($user, $data);
    }

    public function delete(User|int|string $user): bool
    {
        return $this->userRepository->delete($user);
    }

    public function toggleStatus(User|int|string $user): User
    {
        $user = $user instanceof User ? $user : $this->userRepository->findByIdOrFail($user);
        return $this->userRepository->update($user, [
            'is_active' => !$user->is_active,
        ]);
    }
}
