<?php
namespace App\Model;
use Nette;


class Company extends BaseObject
{
    public function __construct(Nette\Database\Context $database)
	{
        parent::__construct($database);
        $this->table = 'companies';
	}
}