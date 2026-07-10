<?php

namespace App\Repositories;

use Illuminate\Database\Eloquent\Builder;
use Illuminate\Database\Eloquent\Collection;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;
use Illuminate\Pagination\LengthAwarePaginator;

abstract class BaseRepository
{
    protected Model $model;

    public function __construct(Model $model)
    {
        $this->model = $model;
    }

    public function all(array $columns = ['*']): Collection
    {
        return $this->model->all($columns);
    }

    public function paginate(int $perPage = 15, array $columns = ['*']): LengthAwarePaginator
    {
        return $this->model->paginate($perPage, $columns);
    }

    public function paginateWithTrashed(int $perPage = 15, array $columns = ['*']): LengthAwarePaginator
    {
        return $this->model->withTrashed()->paginate($perPage, $columns);
    }

    public function paginateOnlyTrashed(int $perPage = 15, array $columns = ['*']): LengthAwarePaginator
    {
        return $this->model->onlyTrashed()->paginate($perPage, $columns);
    }

    public function findById(int|string $id, array $columns = ['*']): ?Model
    {
        return $this->model->find($id, $columns);
    }

    public function findByIdOrFail(int|string $id, array $columns = ['*']): Model
    {
        return $this->model->findOrFail($id, $columns);
    }

    public function findByIdWithTrashed(int|string $id, array $columns = ['*']): ?Model
    {
        return $this->model->withTrashed()->find($id, $columns);
    }

    public function findByField(string $field, mixed $value, array $columns = ['*']): Collection
    {
        return $this->model->where($field, $value)->get($columns);
    }

    public function findFirstByField(string $field, mixed $value, array $columns = ['*']): ?Model
    {
        return $this->model->where($field, $value)->first($columns);
    }

    public function create(array $data): Model
    {
        return $this->model->create($data);
    }

    public function update(Model|int|string $model, array $data): Model
    {
        if (!($model instanceof Model)) {
            $model = $this->findByIdOrFail($model);
        }

        $model->update($data);

        return $model->fresh();
    }

    public function delete(Model|int|string $model): bool
    {
        if (!($model instanceof Model)) {
            $model = $this->findByIdOrFail($model);
        }

        return $model->delete();
    }

    public function forceDelete(Model|int|string $model): bool
    {
        if (!($model instanceof Model)) {
            $model = $this->findByIdOrFail($model);
        }

        return $model->forceDelete();
    }

    public function restore(Model|int|string $model): bool
    {
        if (!($model instanceof Model)) {
            $model = $this->findByIdWithTrashed($model);
        }

        if (!$model) {
            return false;
        }

        return $model->restore();
    }

    public function query(): Builder
    {
        return $this->model->newQuery();
    }

    public function queryWithTrashed(): Builder
    {
        return $this->model->withTrashed();
    }

    public function count(): int
    {
        return $this->model->count();
    }
}
