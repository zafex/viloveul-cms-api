<?php

namespace App\Entity;

use App\Model;
use App\Entity\User;

class Menu extends Model
{
    /**
     * @var array
     */
    protected $fillable = [
        'id',
        'author_id',
        'label',
        'description',
        'content',
        'status',
        'created_at',
        'updated_at',
        'deleted_at',
    ];

    /**
     * @var string
     */
    protected $table = 'menu';

    /**
     * @return mixed
     */
    public function author()
    {
        return $this->belongsTo(User::class);
    }

    /**
     * @param $value
     */
    public function setStatusAttribute($value)
    {
        $this->attributes['status'] = abs($value);
    }
}
