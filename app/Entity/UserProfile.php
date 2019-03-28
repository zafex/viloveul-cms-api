<?php

namespace App\Entity;

use App\Model;
use App\Entity\User;

class UserProfile extends Model
{
    /**
     * @var array
     */
    protected $fillable = [
        'id',
        'user_id',
        'name',
        'value',
        'last_modified',
    ];

    /**
     * @var string
     */
    protected $table = 'user_profile';

    /**
     * @return mixed
     */
    public function user()
    {
        return $this->belongsTo(User::class);
    }
}
