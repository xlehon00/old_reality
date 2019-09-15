<?php

namespace App\Presenters;

use Nette;


/**
 * Base presenter for all application presenters.
 */
abstract class BasePresenter extends Nette\Application\UI\Presenter
{
    /**
	 * Before-render routines
	 * @return void
	 */

	protected function beforeRender() 
	{
		$user = $this->getUser();
		$this->template->user = ($user->isLoggedIn()) ? $user->getIdentity() : NULL;
                $this->template->isLogged = ($user->isLoggedIn()) ? TRUE : FALSE;
        $this->template->monthNamesShort = [
        	'01', '02', '03', '04', '05', '06', 
        	'07', '08', '09', '10', '11', '12'
    	];
    	$this->template->dayNames = [
    		'Thứ hai', 'Thứ ba', 'Thứ tư', 'Thứ năm', 'Thứ sáu', 'Thứ bẩy', 'Chủ nhật'
		];
		$this->template->dayNamesMin = ['T2', 'T3', 'T4', 'T5', 'T6', 'T7', 'CN'];
		$this->template->dateFormat = 'dd/mm/yy';
	}
}
