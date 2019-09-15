<?php

namespace App\Forms;

use Nette;
use Nette\Application\UI\Form;
use Nette\Security\User;
use App\Model\Company;

class CompanyFormFactory
{
    /** @var FormFactory **/
    private $factory;
    
    /** @var Company */
    private $model;
    
    public function __construct(FormFactory $factory) {
        $this->factory = $factory;
    }
    
    /**
     * Create new one or edit existing one
     * @var int $idCompany
     * @var callable $onSuccess
     * @return Form $form
     */
    public function create($idCompany = NULL, callable $onSuccess = NULL) 
    {
        $form = $this->factory->create();
        $form->addText('companyName', 'Tên công ty (văn phòng môi giới): ')
            ->setRequired()
            ->addRule(Form::FILLED, 'Bạn cần điền tên công ty');
        $form->addText('identificationNumber', 'Số ICO')
            ->setRequired()
            ->addRule(Form::PATTERN, 'Bạn cần điền đúng số ICO', '[0-9]{8}');
        $form->addText('addressStreet', 'Địa chỉ (tên phố và số nhà): ')
            ->setRequired();
        $form->addText('postalCode', 'Số bưu điện (PSC): ')
            ->setRequired()
            ->addRule(Form::PATTERN, 'Bạn hãy nhập số bưu điện', '[0-9]{5}');
        $form->addText('telephone', 'Số điện thoại (cố định): ')
            ->setRequired()
            ->addRule(Form::PATTERN, 'Bạn hãy điền theo mẫu', '^(\+420)? ?[1-9][0-9]{2} ?[0-9]{3} ?[0-9]{3}$' );
        $form->addText('mobile', 'Số điện thoại di động: ')
            ->setRequired()
            ->addRule(Form::PATTERN, 'Bạn hãy điền theo mẫu', '^(\+420)? ?[1-9][0-9]{2} ?[0-9]{3} ?[0-9]{3}$' );
        $form->addText('email', 'Email: ')
            ->setRequired()
            ->addRule(Form::PATTERN, 'Bạn hãy điền địa chỉ email công ty', '\b[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,}\b');
        $form->addSubmit('submit', 'Nhập dữ liệu công ty');
        $form->addButton('searchARES', 'Tìm dữ liệu trên ARES');
        $form->onSuccess[] = [$this, 'formSubmitted'];

		return $form;
    }
    
    /** @var Form $form **/
    public function formSubmitted(Form $form)
    {
        $values = $form->getValues();
        $params = array(
            'id' => $values['idCompany'],
            'identification_number' => $values['identificationNumber'],
            'address' => $values['addressStreet'], 
            'postal_code' => $values['postalCode'],
            'telephone' => $values['telephone'],
            'mobile' => $values['mobile'], 
            'email' => $values['email']
        );
        try {
            $this->model->save($values);
        } catch (Model\DuplicateNameException $e) {
            $form['companyName']->addError('Công ty đã tồn tại');
            return;
        }
    }
}

