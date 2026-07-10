<?php

declare(strict_types=1);

namespace Database\Seeders;

use App\Models\Permission;
use App\Models\Role;
use App\Models\User;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\Hash;

class RolePermissionSeeder extends Seeder
{
    public function run(): void
    {
        $permissions = [
            ['name' => 'Manage Users', 'slug' => 'users.manage', 'description' => 'Create, edit, delete users'],
            ['name' => 'Manage Roles', 'slug' => 'roles.manage', 'description' => 'Create, edit, delete roles'],
            ['name' => 'Manage Bookings', 'slug' => 'bookings.manage', 'description' => 'Manage all bookings'],
            ['name' => 'Manage Drivers', 'slug' => 'drivers.manage', 'description' => 'Manage drivers'],
            ['name' => 'Manage Workers', 'slug' => 'workers.manage', 'description' => 'Manage workers'],
            ['name' => 'Manage Services', 'slug' => 'services.manage', 'description' => 'Manage services & categories'],
            ['name' => 'Manage Payments', 'slug' => 'payments.manage', 'description' => 'Manage payments & refunds'],
            ['name' => 'Manage Wallet', 'slug' => 'wallet.manage', 'description' => 'Manage wallet transactions'],
            ['name' => 'Manage Coupons', 'slug' => 'coupons.manage', 'description' => 'Manage coupons'],
            ['name' => 'Manage Promotions', 'slug' => 'promotions.manage', 'description' => 'Manage promotions & campaigns'],
            ['name' => 'Manage HR', 'slug' => 'hr.manage', 'description' => 'Manage HR & employees'],
            ['name' => 'Manage Accounting', 'slug' => 'accounting.manage', 'description' => 'Manage accounting & reports'],
            ['name' => 'Manage Settings', 'slug' => 'settings.manage', 'description' => 'Manage system settings'],
            ['name' => 'View Reports', 'slug' => 'reports.view', 'description' => 'View reports & analytics'],
        ];

        foreach ($permissions as $perm) {
            Permission::firstOrCreate(
                ['slug' => $perm['slug']],
                [...$perm, 'guard_name' => 'web']
            );
        }

        $superAdminRole = Role::firstOrCreate(
            ['slug' => 'super-admin'],
            [
                'name' => 'Super Admin',
                'description' => 'Full system access',
                'guard_name' => 'web',
            ]
        );

        $adminRole = Role::firstOrCreate(
            ['slug' => 'admin'],
            [
                'name' => 'Admin',
                'description' => 'Administrative access',
                'guard_name' => 'web',
            ]
        );

        $managerRole = Role::firstOrCreate(
            ['slug' => 'manager'],
            [
                'name' => 'Manager',
                'description' => 'Managerial access',
                'guard_name' => 'web',
            ]
        );

        $csrRole = Role::firstOrCreate(
            ['slug' => 'csr'],
            [
                'name' => 'Customer Service',
                'description' => 'Customer service representative',
                'guard_name' => 'web',
            ]
        );

        $customerRole = Role::firstOrCreate(
            ['slug' => 'customer'],
            [
                'name' => 'Customer',
                'description' => 'Regular customer',
                'guard_name' => 'web',
            ]
        );

        $driverRole = Role::firstOrCreate(
            ['slug' => 'driver'],
            [
                'name' => 'Driver',
                'description' => 'Service driver',
                'guard_name' => 'web',
            ]
        );

        $allPermissions = Permission::all();

        $superAdminRole->syncPermissions($allPermissions);
        $adminRole->syncPermissions($allPermissions);

        $excludedForManager = ['settings.manage', 'roles.manage'];
        $managerRole->syncPermissions(
            $allPermissions->whereNotIn('slug', $excludedForManager)
        );

        $csrPermissions = ['bookings.manage', 'drivers.manage', 'workers.manage'];
        $csrRole->syncPermissions(
            $allPermissions->whereIn('slug', $csrPermissions)
        );

        $adminUser = User::firstOrCreate(
            ['email' => 'tareq.abd@hotmail.com'],
            [
                'name' => 'Super Admin',
                'password' => Hash::make('T@ghreed81'),
                'is_active' => true,
            ]
        );
        $adminUser->assignRole($superAdminRole);
    }
}
