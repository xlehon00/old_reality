<?php
namespace App\Forms;
use Nette\Application\UI\Control;

abstract class BaseFormFactory extends Control
{
    /** @var FormFactory @inject **/
    public $factory;

    public $years = array();

	/**
	 * @param string $name
	 */
	public function __construct()
	{
		parent::__construct();
        $this->factory = new FormFactory;
        $this->years = $this->getYears();
	}

	public function getYears() 
	{
		$years = array();
    	$lastYear = date('Y') + 10;
    	for ($i = $lastYear; $i >= 1970; $i--) {
    		$years[(string)$i] = $i;
    	}
    	return $years;
	}
}

