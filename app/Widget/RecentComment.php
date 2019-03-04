<?php

namespace App\Widget;

use App\Component\Widget;
use App\Entity\Comment;

class RecentComment extends Widget
{
    /**
     * @var array
     */
    protected $options = [
        'size' => 10,
    ];

    /**
     * @return mixed
     */
    public function results(): array
    {
        $comments = Comment::where('status', 1)->with(['post', 'author'])->orderBy('id', 'desc')->take($this->options['size'])->get();
        return $comments->toArray();
    }
}