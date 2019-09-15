<?php
namespace App\Presenters;
use Nette\Application\UI\Form;
use Nette\Http\SessionSection;
use Nette\Utils\Image;
use App\Forms\AgentFormFactory;

class AgentPresenter extends BasePresenter
{
        /** @var \App\Forms\AgentFormFactory @inject */
        public $agentFormFactory;
        
        /** @var \App\Forms\CompanyFormFactory @inject */
        public $companyFormFactory;
       
        public function renderDefault() 
        {
            $this->template->agentEditForm = $this['agentEditForm'];
            $this->template->companyEditForm = $this['companyEditForm'];
        }
        
        public function createComponentAgentEditForm()
        {
            $form = $this->agentFormFactory->create();
            return $form;
        }
        
        public function createComponentCompanyEditForm()
        {
            $form = $this->companyFormFactory->create();
            return $form;
        }
}
