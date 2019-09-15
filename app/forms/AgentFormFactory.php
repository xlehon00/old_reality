<?php
namespace App\Forms;

use Nette;
use Nette\Application\UI\Form;
use Nette\Security\User;
use App\Model\Company;
use App\Model\Agent;

class AgentFormFactory
{
    use Nette\SmartObject;
    /** @var FormFactory **/
    private $factory;
    
    /** @var Company @inject **/
    public $company;
    
    /** @var Agent **/
    private $model;
    
    public function __construct(FormFactory $factory, Company $company) {
        $this->factory = $factory;
        $this->company = $company;
    }

    //Create form to add new agent or edit existing agent    
    public function create($idAgent = NULL)
    {
            $form = new Form();
            $form->addText('firstname', 'Tên: ')->setRequired();
            $form->addText('surname', 'Họ: ')->setRequired();
            $form->addText('email', 'Email: ')->setRequired();
            $form->addText('telephone', 'Điện thoại bàn: ');
            $form->addText('mobile', 'Số di động: ')->setRequired();
            
            $companies = $this->company->findAll()->fetchPairs('id', 'name');
            $form->addSelect('company', 'Văn phòng (công ty) trực thuộc: ', $companies);
            $form->addText('ico', 'Số ICO (trong trường hợp không thuộc văn phòng): ');
            $form->addUpload('image', 'Ảnh: ');
            $form->addHidden('idAgent' , $idAgent);
            $form->addSubmit('submit', 'Nhập dữ liệu');
            $form->onSuccess[] = [$this, 'formSubmitted'];
            return $form;
    }

    public function formSubmitted($form)
    {
            $values = $form->getValues();
            if ($values['image']->isOk() && $values['image']->isImage()) {
                    $image = $values['image'];
                    $imageName = rand(1, 100) . $image->getName();
                    $image->move($this->context->parameters['wwwDir'] . '/images/agents/' . $imageName);
            }
            $params = array(
                    'id' => $values['idAgent'],
                    'firstname' => $values['firstname'],
                    'surname' => $values['surname'],
                    'email' => $values['email'], 
                    'telephone' => $values['telephone'],
                    'mobile' => $values['mobile'],
                    'id_company' => $values['company'], 
                    'ico' => $values['ico'], 
                    'image' => $imageName
            );
            $this->model->save($params);
            $this->flashMessage('Bạn đã nhập thành công thông tin về chuyên viên.', 'success');
            $this->redirect('this');
    }
}
