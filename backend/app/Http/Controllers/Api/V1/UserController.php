<?php

declare(strict_types=1);

namespace App\Http\Controllers\Api\V1;

use App\Http\Controllers\Controller;
use App\Http\Resources\Api\V1\UserResource;
use App\Services\UserService;
use App\Traits\ApiResponse;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class UserController extends Controller
{
    use ApiResponse;

    public function __construct(
        private readonly UserService $userService,
    ) {}

    public function index(Request $request): JsonResponse
    {
        $users = $this->userService->list();

        return $this->paginated($users);
    }

    public function show(int $id): JsonResponse
    {
        $user = $this->userService->find($id);

        if (!$user) {
            return $this->notFound('User not found');
        }

        return $this->success(
            new UserResource($user->load('roles.permissions'))
        );
    }

    public function destroy(int $id): JsonResponse
    {
        $deleted = $this->userService->delete($id);

        if (!$deleted) {
            return $this->notFound('User not found');
        }

        return $this->success(null, 'User deleted successfully');
    }

    public function toggleStatus(int $id): JsonResponse
    {
        $user = $this->userService->toggleStatus($id);

        return $this->success(
            new UserResource($user),
            'User status updated'
        );
    }
}
