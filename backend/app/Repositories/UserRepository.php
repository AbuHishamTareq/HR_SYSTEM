<?php

namespace App\Repositories;

use App\Models\User;

class UserRepository extends BaseRepository
{
    public function __construct(User $user)
    {
        parent::__construct($user);
    }

    public function findByEmail(string $email): ?User
    {
        return $this->findFirstByField('email', $email);
    }

    public function findByPhone(string $phone): ?User
    {
        return $this->findFirstByField('phone', $phone);
    }

    public function findActiveUsers(): mixed
    {
        return $this->query()->where('is_active', true)->paginate();
    }

    public function syncRoles(User $user, array $roleIds): void
    {
        $user->roles()->sync($roleIds);
    }
}
