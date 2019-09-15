<?php

namespace App\Model;
use Nette;


class Client extends BaseObject
{
    public function __construct()
	{
        $this->table = 'clients';
	}
}

