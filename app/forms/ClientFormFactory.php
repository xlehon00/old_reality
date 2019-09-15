<?php
namespace App\Forms;

use Nette;
use Nette\Application\UI\Form;
use App\Model\Company;
use App\Model\Agent;
use App\Model\Client;

class ClientFormFactory extends BaseFormFactory
{
    private $values = array();
    /** @var Client **/
    private $model;
    
    /**
	 * @param string $name
	 */
    public function __construct() {
        parent::__construct();
        $this->model = new Client;
    }
    
    /**
    * @return Form
    */
    public function create($idClient = NULL) 
    {
        $form = $this->factory->create();
        $form->getElementPrototype()->class('ajax');
        $form->addText('firstname', 'Tên:');
        $form->addText('surname', 'Họ');
        $form->addText('birthday', 'Ngày tháng năm sinh:');
        $form->addText('telefon', 'Số điện thoại');
        $form->addText('mobileNumber', 'Số di động')->setRequired('Di động là mục bắt buộc');
        $form->addEmail('email', 'Email');
        $form->addHidden('idClient', $idClient);
        $form->addSubmit('save', 'Nhập khách hàng')->getControlPrototype()->class('ajax');
        if ($this->values) {
            $form->setDefaults($this->values);
        }
        $form->onSuccess[] = [$this, 'formSubmitted'];

        return $form;
    }

    public function formSubmitted(Form $form) 
    {
        
        $values = $form->getValues();
        $this->values = $values;
        $clientInfos = array(
                'id' => $values['idClient'],
                'firstname' => $values['firstname'],
                'surname' => $values['surname'],
                'birthday' => $values['birthday'],
                'telefon' => $values['telefon'],
                'mobile_number' => $values['mobileNumber'], 
                'email' => $values['email']
        );
        
        $this->model->save($clientInfos);
    }
        
}

