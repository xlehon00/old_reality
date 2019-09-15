<?php
namespace App\Forms;

use Nette;
use Nette\Application\UI\Form;
use Nette\Security\User;
use App\Model\Company;
use App\Model\Estate;
use App\Model\Agent;
use App\Model\Geology;
use App\Model\ImageStorage;
use Nette\Utils\Image;
use App\Model\Helper;

class EstateFormFactory extends BaseFormFactory
{
    const SALE = 1,
          LEASE = 2;

    /** @var Agent **/
    private $agentModel;
    
    /** @var Geology **/
    private $geologyModel;
    
    /** @var Company **/
    private $companyModel;

    /** @var ImageStorage **/
    private $imageStorage;
    
    /** @var Estate */
    private $model;

    /** @var Helper @inject **/
    public $helper;


    /** @var array */
    private $contractTypes = [
                '1' => 'Độc quyền', 
                '2' => 'Không độc quyền', 
                '3' => 'Cùng độc quyền'
            ];
    /** @var array **/
    private $ownerships = [
                '1' => 'Tư nhân', 
                '2' => 'Hợp tác xã', 
                '3' => 'Nhà nước, ủy ban'
            ];

    private $orderTypes = ['1' => 'Bán', '2' => 'Cho thuê'];
    public $manifoldsByCat = array();
    public function __construct(Agent $agentModel, Geology $geologyModel, 
                                        Company $companyModel, Estate $estateModel, 
                                        ImageStorage $imageStorage, Helper $helper) {
        parent::__construct();
        $this->agentModel = $agentModel;
        $this->geologyModel = $geologyModel;
        $this->companyModel = $companyModel;
        $this->imageStorage = $imageStorage;
        $this->helper = $helper;
        $this->model = $estateModel;
    }
    
    /**
     * Create new one or edit existing one
     * @var int $idCompany
     * @var callable $onSuccess
     * @return Form $form
     */
    public function create($idEstate = NULL, callable $onSubmit = NULL) 
    {
        $form = $this->factory->create();
        $form->getElementPrototype()->setAttribute('class', 'ajax');
        $form->addHidden('id', $idEstate);
        $form->addText('title', 'Tiêu đề:');//->addRule(Form::FILLED, 'Zadejte titulek nabídky');
        $form->addTextArea('description', 'Nội dung chi tiết', 60, 10);//->addRule(Form::FILLED, 'Zadejte detailní popis');
        $form->addText('internalNumber', 'Số đơn hàng');//->addRule(Form::FILLED, 'Zadejte interní číslo zákazky');
        $res = $this->agentModel->findByColumns(array('id', 'firstname', 'surname'));
        $agents = array();
        foreach ($res as $agent) {
                $agents[$agent['id']] = $agent['firstname'] . ' ' . $agent['surname'];
        }
        $form->addSelect('agentId', 'Chuyên viên môi giới', $agents);
        
        
        $categories = $this->model->getCategories();
        $form->addSelect('categoryId', 'Dạng bất động sản', $categories)
			->setRequired('Bạn cần lựa chọn dạng bất động sản')
            ->setPrompt('Lựa chọn: dạng bất động sản');
        $projectCategories = $categories;
        unset($projectCategories[3]); //3 is project category id
        $form->addSelect('projectCategoryId', 'Dạng bất động sản của dự án', $projectCategories)
            ->setRequired('Bạn cần nêu rõ dạng công trình');
        
        $houseDispositions = array();
        $form->addSelect('houseDisposition', 'Số phòng (nhà hộ gia đình)', $houseDispositions)
            ->setPrompt('Lựa chọn: Số phòng (nhà hộ gia đình)');

        $types = array();
        //we will add select values when orderType and category are set
        $form->addSelect('type', 'Loại hình bất động sản', $types)
            ->setPrompt('Lựa chọn: loại hình bất động sản');
        
        $states = $this->model->getStates();
        $form->addSelect('state', 'Tình trạng bất động sản', $states)
            ->setPrompt('Lựa chọn: tình trạng bất động sản');
        
        $form->addSelect('orderType', 'Lựa chọn: Dạng đơn hàng', $this->orderTypes)
			->setRequired('Bạn cần lựa chọn dạng đơn hàng')
            ->setPrompt('Lựa chọn: Dạng giao dịch');
        
        $form->addSelect('contractType', 'Dạng hợp đồng', $this->contractTypes)
			->setRequired('Bạn cần lựa chọn dạng hợp đồng')
            ->setPrompt('Lựa chọn: Dạng hợp đồng');
        
        $form->addSelect('ownership', 'Sở hữu:', $this->ownerships)
			->setRequired('Bạn cần lựa chọn dangj sở hữu')
            ->setPrompt('Lựa chọn: Dạng sở hữu');

        $res = $this->geologyModel->setTable('regions')->findByColumns(array('id', 'name'))->fetchAll();
        $regions = [];
        foreach ($res as $region) {
            $regions[$region->id] = $region->name;
        }
        $form->addSelect('regionId', 'Vùng (miền) :', $regions)->setPrompt('Lựa chọn vùng')->setHtmlAttribute('data-placeholder', 'Lựa chọn vùng');

        $form->addSelect('districtId', 'Tỉnh (thành phố):', array())
                ->setPrompt('Lựa chọn tỉnh (thành phố)')->setRequired()
                ->setHtmlAttribute('data-placeholder', 'Lựa chọn tỉnh (thành phố)');

        $form->addSelect('villageId', 'Quận (huyện):', array())->setPrompt('Lựa chọn quận (huyện)')
                ->setHtmlAttribute('data-placeholder', 'Lựa chọn quận (huyện)');
        $form->addSelect('villagePartId', 'Khu vực:', array())
            ->setPrompt('Lựa chọn khu vực');
        $form->addSelect('streetId', 'Phố:', array())
                ->setPrompt('Lựa chọn phố')
                ->setHtmlAttribute('data-placeholder', 'Lựa chọn phố');

        $form->addText('gpsLatitude', 'GPS vĩ độ:');//->addRule(Form::FILLED, 'Zadejte GPS šířku');
        $form->addText('gpsLongitude', 'GPS kinh độ:');//->addRule(Form::FILLED, 'Zadejte GPS délku');
        
        
        /****** Next is part of price infos **********/
        //Category: 1 - Flat, 2 - House, 3 - Project, 4 - Land, 5 - Commercial area, 6 - Others
     
        $res = $this->model->getDealUnits(self::SALE);
        $form->addText('price', 'Giá giao dịch')
            ->setRequired('Bạn cần xác định gía')
            ->addRule(FORM::INTEGER, 'Bạn hãy kiểm tra giá')
            ->addRule(FORM::MIN, 'Gía phải lớn hơn 0', 1);
        //$form['price']->getControlPrototype()->setAttribute('class', 'category-1-2-4-5');
        $params = [NULL => 'Lựa chọn: đơn vị giao dịch'];
        $params += $res->fetchPairs('id', 'name');
        $form->addSelect('dealUnit', 'Đơn vị mua bán', $params);

  
        $form->addText('deposit', 'Tiền đặt cọc');
        $form->addText('feeFromLessor', 'Phí dịch vụ từ người cho thuê');
        $form->addText('feeFromLessee', 'Phí dịch vụ từ người thuê');

        $currencies = array('1' => 'CZK', '2' => 'EUR', '3' => 'USD');
        $form->addSelect('currency', 'Đơn vị tiền tệ', $currencies)
			->setDefaultValue(1)
			->setPrompt('Lựa chọn: đơn vị tiền');
        $form->addText('noteToPrice', 'Chú thích về giá');   //about law servis, agent fee ...

        $referenceFeeTypes = array(NULL => 'Lựa chọn: hình thức phí dịch vụ', 'Khoản xác định', 'Phần trăm');
        $form->addText('referenceFeeType', 'Hình thức phí dịch vụ', $referenceFeeTypes);
        $form->addText('referenceFeeInPercent', 'Phần trăm phí dịch vụ');
        $form->addText('referenceFeeInAmount', 'Toàn bộ phí dịch vụ (không tính thuế DPH trong đơn vị Kč');
                
        $result = $this->companyModel->findByColumns(array('id', 'name'))->fetchPairs('id', 'name');
        $companies = [NULL => 'Lựa chọn: công ty (văn phòng) môi giới'] + $result;
        $form->addSelect('companyId', 'Công ty (văn phòng) môi giới: ', $companies);
        
        
        /**************** More detail infos about estate ********************/
        $form->addText('dateOfMoving', 'Ngày chuyển đi');
        $form->addSelect('yearOfReconstruction', 'Năm tu sửa', $this->getYears())->setPrompt('Lựa chọn:');
        $form->addSelect('yearOfApproval', 'Năm được cấp phép hoạt động', $this->getYears())->setPrompt('Lựa chọn:');
        $form->addSelect('yearOfBuildingUp', 'Năm hoàn thành xây dựng', $this->getYears())->setPrompt('Lựa chọn:');

        //additions
        $additions = array(
                'Thang máy',
                'Ban công',
                'Hành lang ngoài',
                'Sân thượng',
                'Tầng hầm',
                'Ga-ra để xe',
                'Vườn trước',
                'Chỗ đỗ xe'
        );
        $form->addCheckboxList('flatAddingInfos', 'Các diện tích trực thuộc khác', $additions);
    
        $form->addText('annualEnergyConsumption', 'Mức độ tiêu thụ năng lượng hàng năm theo tính toán đơn vị kWh/m2/rok');
        $form->addUpload('scanEnergyTag', 'Scan phiếu kiểm định chỉ số sử dụng năng lượng');
        $form->addButton('sendScanEnergyTag', 'Gửi');

        //expert setting
        $form->addText('urlVirtualTour', 'URL giới thiệu nhà trong không gian mô phỏng');
        $form->addCheckbox('garage', 'Ga-ra');
        $form->addCheckbox('parking', 'Chỗ đỗ xe');
        $categories = $this->model->getCategories();
        foreach ($categories as $categoryId => $name) {
            $manifolds = $this->model->getManifoldsOfCategory($categoryId);
            if ($manifolds && count($manifolds)) {
                foreach ($manifolds as $manifold) {
                    if (isset($manifold->parent_id)) {
                        continue;  //if a manifold has the parent, we continue
                    } else {
                        $name = $this->model->setUrlToCamelCaseName($manifold->url);
                        switch ($manifold->type) {
                            case 'text':        //if type is text, its value is for area
                                $form->addText($name, $manifold->name)
                                    ->setRequired(false)
                                    ->addRule(FORM::INTEGER, 'Diện tích phải là số')
                                    ->addRule(FORM::MIN, 'Diện tích nhỏ nhất là 1 m2', 1);
                                break;
                            case 'checkbox':
                                $form->addCheckbox($name, $manifold->name);
                                break;
                            case 'checkbox-list':
                                $options = $this->model->getManifoldOptionsByParent($manifold->id)->fetchPairs('id', 'name');
                                $form->addCheckboxList($name, $manifold->name, $options);
                                break;
                            case 'select': 
                                $options = $this->model->getManifoldOptionsByParent($manifold->id)->fetchPairs('id', 'name');
                                $form->addSelect($name, $manifold->name, $options)->setPrompt('Lựa chọn:');
                                break;
                            default:
                        }

                        $this->manifoldsByCat[$categoryId][$manifold->id] = [];
                        $this->manifoldsByCat[$categoryId][$manifold->id]['name'] = $manifold->name;
                        $this->manifoldsByCat[$categoryId][$manifold->id]['attributeName'] = $name;
                        $this->manifoldsByCat[$categoryId][$manifold->id]['houseDisposition'] = $manifold->type;
                    }
                }
            }
        }
        
        $parentManifolds = $this->model->getParentManifolds()->fetchAll();
        foreach ($parentManifolds as $parent) {
            $manifolds = $this->model->getManifoldOptionsByParent($parent->id)->fetchPairs('id', 'name');
            $name = $this->model->setUrlToCamelCaseName($parent->url);
            if ($parent->type == 'checkbox-list') {
                $form->addCheckboxList($name, $parent->name, $manifolds);
            } elseif ($parent->type == 'select') {
                $form->addSelect($name, $parent->name, $manifolds)->setPrompt('Lựa chọn:');
            }
        }
        
        //marketing
        $form->addCheckbox('sail', 'Phông bạt quảng cáo');
        $form->addSelect('specification', 'Đánh dấu', array('rezidential'));
        $form->addSelect('noPublicOrder', 'Đơn hàng không công khai', array('Không', 'Có'))->setDefaultValue('0');
        
        
        /********** Flat infos ************/
        $form->addText('floor', 'Tầng của căn hộ');
        $form->addText('numberOfFloors', 'Số tầng của công trình');
        
        //area infos
        $form->addText('overallArea', 'Tổng diện tích')
            ->setRequired('Bạn cần điền tổng diện tích')
            ->addRule(FORM::INTEGER)
            ->addRule(FORM::MIN,'Diện tích tối thiểu phải lớn hơn 1', 1);
        $form->addText('respectiveLand', 'Phần đất trực thuộc');
        $form->addText('projectDateOfSale', 'Ngày bắt đầu rao bán');
        $form->addText('projectDateOfFinish', 'Ngày hoàn thành dự án');
        
        /**** here are additions ***/
        
        $form->addText('numberOfParkingPlaces', 'Số lượng chỗ đỗ xe');

        $form->addCheckbox('landBuildIn', 'Công trình khác (không để ở) thuộc khu đất');
        $form->addText('numberOfFlatsUnderground', 'Số tầng ngầm dưới mặt đất');
        $form->addText('ceilingHeight', 'Độ cao của trần nhà');

        /*$equipment = array(
            'Có trang thiết bị đầy đủ', 
            'Có trang thiết bị một phần',
            'Không trang thiết bị');
        $form->addSelect('equipment', 'Trang thiết bị', $equipment);
        $form->addTextArea('equipmentDescription', 'Miêu tả trang thiết bị');*/
        
        /**** End flat infos *****/
        /***** House infos ********/
        $form->addText('areaForUse', 'Diện tích sử dụng');
        $form->addText('areaBuilt', 'Diện tích xây dựng');
        $form->addText('areaOfLot', 'Diện tích đất');
        $form->addText('areaOfGarden', 'Diện tích vườn');
        $form->addText('usedAreaOnGroundFloor', 'Diện tích sử dụng ở tầng mặt đất');
        $form->addText('areaOfOutsideCommunications', 'Diện tích bên ngoài');
                
        /*** here are additions **/
        $form->addText('numberOfFlats', 'Tổng số căn hộ trong nhà');
        $form->addCheckbox('trees', 'Cây cối');
        /****** End house infos  ****/
        /******Begin commercial object infos *******/
        $areaInfos = array(
                'totalArea' => 'Tổng diện tích',
                'manufacturingArea' => 'Diện tích sản xuất',
                'operatingArea' => 'Diện tích hoạt động',
                'buildUpArea' => 'Diện tích xây dựng',
                'plotArea' => 'Diện tích được bao hàng rào',
                'parcelArea' => 'Diện tích đất đăng ký',
                'areaOfStorage' => 'Diện tích kho bãi',
                'salesArea' => 'Diện tích bán hàng'
        );  
        
        foreach ($areaInfos as $key => $value) {
                $form->addText($key, $value);
        }
        /******** End commercial object infos **********/
        /******** Begin shack infos *********/
        $shackTypes = array(
            NULL => 'Lựa chọn: mẫu nhà nghỉ', 
            'Nhà gỗ (xây với mục đích nghỉ dưỡng)', 
            'Nhà gỗ ở nông trang');
        $form->addSelect('shackType', 'Mẫu nhà nghỉ dưỡng', $shackTypes);
        $form->addCheckbox('swimmingPool', 'Bể bơi');
        /******* End shack infos ******/
        
        /****** Begin garage infos ******/
         //dimensions
        $form->addText('width', 'Chiều rộng');
        $form->addText('length', 'Chiều dài');
        $form->addText('height', 'Chiều cao');
        /****** End garage infos ****/
        
        /****** Begin commercial areas infos ********/

        $form->addText('officesArea', 'Diện tích văn phòng');
        $form->addText('numberOfAbovegroundFloors', 'Số tầng trên mặt đất của công trình');

        //adding infos
        $form->addSelect('saleInWhole', 'Bán toàn bộ', 
            array(NULL => 'Lựa chọn: bán toàn bộ', 'Bán toàn bộ', 'Bán toàn phần'));    
        $form->addText('numberOfOffices', 'Số lượng văn phòng');
        /****** End commercial areas infos *******/
        
        /***** Begin hotel and restaurant infos *********/
        $facilityTypes = array('Lựa chọn: Loại hình dịch vụ', 'Hotel', 'Restaurace', 'Penzion');
        $form->addSelect('facilityType', 'Loại hình dịch vụ', $facilityTypes);

        $form->addTextArea('descriptionOfOtherNonresidentialSpaces', 'Popis ostatních nebytových prostor');
        /******** End hotel and restaurant infos *******/
        
         /****** Upload images of estate **********/
        $form->addMultiUpload('images', 'Đăng ảnh')->addCondition(Form::FILLED)->addRule(Form::IMAGE, 'Ảnh cần thuộc dạng tệp JPEG, GIF  hoặc PNG');
        
        $form->addSubmit('save', 'Hoàn thành');
        $form->onSubmit[] = array($this, 'formSubmitted');
        return $form;
    }
   
    public function formSubmitted(Form $form)
    {        
        //check and get id of street and village
        $values = $form->getParent()->getHttpRequest()->getPost();
        $dateAttributes = ['dateOfMoving', 'projectDateOfFinish', 'projectDateOfSale'];

        foreach ($dateAttributes as $attributeName) {            
            if (isset($values[$attributeName]) && $values[$attributeName] != '') {
                $dateParts = explode('/', $values[$attributeName]);
                $values[$attributeName] = (new \DateTime())->setDate($dateParts[2], 
                    $dateParts[1], $dateParts[0]); 
            }
        }
       
        unset($values['_do']);
        unset($values['save']);
        $images = $form->getValues()['images']; //images can't be serialized so we get it like this 
        $manifoldUrls = $this->model->getAvailableManifolds($values['categoryId'])->fetchPairs('id', 'url');
        $estateInfos = array();
        $manifoldsData = array();

        foreach ($values as $key => $value) {
            $keyWithHyphens =strtolower(preg_replace('/([A-Z])/', '-$1', $key));
            if (in_array($keyWithHyphens, $manifoldUrls)) {
                 if (isset($value) && $value) {
                    $manifoldsData[$keyWithHyphens] = $value;
                }
            } else {
                $keyWithUndercore = strtolower(preg_replace('/([A-Z])/', '_$1', $key));
                if (isset($value) && $value) {
                    $estateInfos[$keyWithUndercore] = $value;
                }
            }
        }

        $idEstate = $this->model->save($estateInfos);
        $this->model->saveManifoldValuesOfEstate($manifoldsData, $idEstate); //save manifold values to relation 
        $this->saveImages($images, $idEstate);
    }

    /**
     * Save images to files
     * @param $images
     */
    private function saveImages($images, $idEstate)
    {
        $imagesFileName = $idEstate;
        $i = $this->helper->countFiles(IMAGE_DIR . '/' . $imagesFileName);
        foreach ($images as $image) {
            if ($image->isImage() && $image->isOk()) {
                $fileExt = strtolower(mb_substr($image->getSanitizedName(), strrpos($image->getSanitizedName(), ".")));
                $imageName = $imagesFileName . '_' . ++$i . $fileExt;
                //\Tracy\Debugger::fireLog($imageName); die;
                $this->imageStorage->save($imagesFileName . '/' . $imageName, $image);
                //miniature
                $miniature = Image::fromFile($this->imageStorage->getDir() . '/' . $imagesFileName . '/' . $imageName);
                if ($miniature->getWidth() > $miniature->getHeight()) {
                    $miniature->resize(140, NULL);
                } else {
                    $miniature->resize(NULL, 140);
                }
                $miniature->sharpen();
                $thumbsFile = $this->imageStorage->getDir() . "/thumbs/" . $imagesFileName;
                if (!file_exists($thumbsFile)) {
                    mkdir($thumbsFile, 0777, TRUE);
                }
                $miniature->save($thumbsFile . '/' . $imageName);
            }
        }
    }
}