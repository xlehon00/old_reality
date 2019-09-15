<?php

namespace App\Presenters;
use Nette\Application\UI\Form;
use Nette\Http\SessionSection;
use Nette\Utils\Image;

class ClientPresenter extends BasePresenter
{
        private $database;
        public function __construct(\Nette\Database\Context $database) {
            parent::__construct();
            $this->database = $database;
        }
        
        public function renderDefault() 
        {
                $this->setView('edit');
        }
        
        public function createComponentClientForm() {
                return new \ClientControl($this->database);
        }


        public function actionEdit($idClient) 
        {
                $this->template->form = $this['clientForm'];
        }

        
}