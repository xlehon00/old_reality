<?php

namespace App\Presenters;
use Nette\Application\UI\Form;
use Nette\Http\SessionSection;
use Nette\Utils\Image;
use App\Model\Estate;
use App\Model\Agent;
use App\Model\Helper;

class EstateDetailPresenter extends BasePresenter
{
        /** @var Estate @inject**/
        public $model;

        /** @var Agent @inject **/
        public $agentModel;

        /** @var Helper @inject **/
        public $helper;
        
        public function renderDefault($id)
        {
                $estate = $this->model->findById($id)->fetch();
                $estateData = $this->model->fetchDataToFormAttributes($estate);
                $this->template->estate = $estateData;
                $this->template->thumbsCount = $this->helper->countFiles("../www/images/thumbs/" . $id);
                $this->template->agent = (isset($estateData->agentId)) ? 
                    $this->agentModel->find($estateData->agentId)->fetch() : NULL;
                $this->template->dealUnits = $this->model->getDealUnits()->fetchPairs('id', 'name');
                $this->template->currencies = $this->model->getCurrencies();
                $this->template->types = $this->model->getTypes($estateData->categoryId);
        }
        
        public function createComponentContactForm()
        {
                $form = new Form();
                $form->addText('name', 'Họ tên:')->setRequired();
                $form->addText('mobileNumber', 'Số điện thoại:')->setRequired();
                $form->addText('email', 'Email');
                $form->addTextArea('text', '');
                $form->addHidden('agentId');
                $form->addHidden('estateId');
                $form->addSubmit('submit', 'Gửi');
                $form->onSuccess[] = [$this, 'contactFormSubmitted'];
                return $form;
        }
        
        public function contactFormSubmitted(Form $form)
        {
                $values = $form->getValues();
                $message = array(
                        'customer_name' => $values->name,
                        'telephone' => $values->mobileNumber,
                        'email' => $values->email,
                        'message' => $values->text,
                        'id_agent' => $values->agentId,
                        'id_estate' => $values->estateId
                );
                $this->database->table('messages')->insert($message);
                $this->redirect('this');
        }
}