<?php
namespace App\Presenters;
use Nette\Application\UI\Form;
use Nette\Database\Table;
use App\Model\Geology;
use App\Model\Estate;

class EstateSearchPresenter extends BasePresenter
{
        private $database;
        private $categoryId;
        private $orderType;
        private $streets = null;
        private $villages = null;
        private $villageParts = null;
        private $districts = null;
        private $districtsOrdered = null;
		
		/** @var Geology @inject **/
		private $geologyModel;
		
		/** @var Estate @inject **/
		private $estateModel;
		
		
        public function __construct(\Nette\Database\Context $database, 
                                Geology $geologyModel, Estate $estateModel) {
            parent::__construct();
            $this->database = $database;
            $this->geologyModel = $geologyModel;
            $this->estateModel = $estateModel;
            $this->categoryId = 1;
            $this->orderType = 1;
        }
        
        public function renderDefault($categoryId = 1, $orderType = null)
        {
                $this->categoryId = $categoryId;
                $this->template->orderTypes = $this->estateModel->getOrderTypes();
                $this->template->form = $this['searchForm'];
                $this->template->orderType = $this->orderType;
                $this->template->streets = (isset($this->streets)) ? 
                                $this->streets : $this->geologyModel->getStreetsDataForSearching();
                $this->template->villageParts = isset($this->villageParts) ?
                                $this->villageParts : 
                                $this->geologyModel->getVillagePartsDataForSearching();
                $this->template->districts = isset($this->districts) ? 
                                $this->districts : 
                                $this->geologyModel->getDistrictsDataForSearching();
                $this->template->villages = isset($this->villages) ?
                                $this->villages :
                                $this->geologyModel->getVillagesDataForSearching();
                $this->template->districtsOrdered = isset($this->districtsOrdered) ?
                                $this->districtsOrdered : 
                                $this->geologyModel->getOrderedDistrictsForSearching();
                $defaultParams = array('categoryId' => $this->categoryId, 'orderType' => $this->orderType);
                $this->template->estatesCount = $this->estateModel->countEstatesByParams($defaultParams);
        }
        
        protected function createComponentSearchForm()
        {
                $form = new Form();
                $regions = $this->geologyModel->getRegions();
                $dispositions = $this->estateModel->getDispositions($this->categoryId);
              
                foreach ($regions as $region) {
                        $districts = $region->related('districts.region_id')->fetchPairs('id', 'name');
                        $form->addCheckboxList($region->code, $region->name, $districts);
                }
                $form->addCheckboxList('regionId', '', $regions->fetchPairs('id', 'code'));
                $estateStates = $this->estateModel->getStates();
            
                $form->addHidden('geologyId', '');
                $form->addHidden('geologyType', '');
                $form->addCheckboxList('disposition', 'Loại hình', $dispositions);
                $form->addCheckboxList('state', ' Tình trạng', $estateStates);
                $form->addCheckboxList('structure', 'Cấu trúc', 
                    array('1' => 'Tấm ốp', '2' => 'Gạch', '3' => 'Vật liệu khác'));
                $form->addCheckboxList('ownership', 'Sở hữu', 
                    array('1' => 'Cá nhân', '2' => 'Hợp tác xã', '3' => 'Nhà nước (ủy ban)'));
                $form->addText('priceFrom')->setHtmlAttribute('placeholder', 'Từ:');
                $form->addText('priceTo')->setHtmlAttribute('placeholder', 'Đến:');
                
                $addingInfos = $this->estateModel->getAddingManifoldInfosByCategory($this->categoryId);
                $form->addCheckboxList('manifolds', 'Các hạng mục kèm thêm', $addingInfos);
                $form->addText('autoComplete', 'Tìm kiếm chi tiết');
                $form->addText('floorFrom')->setHtmlAttribute('placeholder', 'Từ:');
                $form->addText('floorTo')->setHtmlAttribute('placeholder', 'Đến:');
                $form->addText('areaFrom')->setHtmlAttribute('placeholder', 'Từ:');
                $form->addText('areaTo')->setHtmlAttribute('placeholder', 'Đến:');
                $form->addSelect('timeSinceAddingAd', 'Thời điểm đăng quảng cáo', 
                        array('0' => 'Không hạn chế', '1' => '1 ngày', 
                            '7' => 'Trong vòng 7 ngày trước', '30' => 'Trong vòng 30 ngày trước'));
                $form->addSubmit('submit', 'Hiện quảng cáo');
                $form->onSubmit[] = [$this, 'searchByCriterions'];

                
                $categories = $this->estateModel->getCategories();
                $category = $this->estateModel->getCategoryById($this->categoryId);
                $this->template->categories = $categories;
                $this->template->estateTypes = $dispositions;
                $this->template->category = $category;
                $this->template->regions = $regions;
                return $form;
        }
        
        
        public function handleGetSpecificAddress()
        {
                $res = $this->database->query('SELECT name FROM streets');
                $streets = iterator_to_array($res);
                $this->payload->streets = $streets;
                $this->sendPayload();
        }
        
        
        public function handleImport() {
            $newFilePath =  "/home/alex/Downloads/obyvatel.csv";
            if (($handle = fopen($newFilePath, "r")) !== FALSE) {
                while (($data = fgetcsv($handle, 1000, ",")) !== FALSE) {
                    $sql = "UPDATE districts SET population = $data[1] WHERE name = '$data[0]'";
                    $this->database->query($sql);
                }
                fclose($handle);
            }
        }
        
        /**
         * Handle searching by criterions
         * @param associative array $criterions
         * @return array $results
         */
        public function searchByCriterions (Form $form)
        {
                $criterions = $form->getValues();
                $params = array();
                foreach ($criterions as $key => $val) {
                        $params[$key] = $val;
                }
            
                $this->redirect('EstatesList:default', $params);
        }
        
        /*
         * Change to other order type
         */
        public function changeOrderType($orderType, $categoryId = null, $defaults = null)
        {
            if (!isset($categoryId)) {
                $categoryId = $this->categoryId;
            }
            $htmlTypes = '';
            $dispositions = $this->estateModel->getDispositions($categoryId, $orderType);
            $this->template->orderType = $orderType;
            $this->template->category = $this->estateModel->getCategoryById($categoryId);

            foreach ($dispositions as $key => $label) {
                $htmlTypes .= "<div class='checkboxes' style='width: 150px'>" . 
                        "<input type='checkbox' class='params' name='disposition[]' value='" . $key 
                        . "'";

                if (isset($defaults['disposition']) && in_array($key, $defaults['disposition'])) {
                    $htmlTypes .= " checked='checked'";
                }
                $htmlTypes .= ">" . $label . "</div>";
            }
            return $htmlTypes;
      
        }

        /** 
         * Change the category of estates
         * @param int $idCategory 
         **/
        public function handleToggleCategory($idCategory)
        {
            $category = $this->estateModel->getCategoryById($idCategory);
            $this->template->category = $category;
            $htmlTypes = '';
            $htmlCategories = '';
            $dispositions = $this->estateModel->getDispositions($idCategory);
            $this->categoryId = $idCategory;
            foreach ($dispositions as $key => $label) {
                $htmlTypes .= "<div class='checkboxes' style='width: 150px'>" . 
                        "<input type='checkbox' class='params' name='type[]' value='" . $key . "'>" . $label .
                        "</div>";
            }
            $categories = $this->estateModel->getCategories();
            unset($categories[$idCategory]);
            foreach ($categories as $id => $name) {
                $href = $this->link('toggleCategory!', $id);
                $htmlCategories .= '<a href="' . $href . '">' . 
                            $name . '</a>';

            }
            $this->payload->dispositions = $htmlTypes;
            $this->payload->categories = $htmlCategories;
            $this->payload->categoryId = $idCategory;
            $this->sendPayload();
        }

        /**
         * Count the number of estates which are filtered by the params
         **/
        public function handleCountEstatesByParams() 
        {
            $params = $this->getHttpRequest()->getQuery();
            if (isset($params['orderType']) && isset($params['categoryId'])) {
                $dispositions = $this->changeOrderType($params['orderType'], $params['categoryId'], $params);
                $this->payload->dispositions = $dispositions;
            }
            unset($params['_do']);
            unset($params['do']);

            foreach ($params as $key => $value) {
                if (strpos($key, 'CZ') !== false) {
                    $params['districtId'] = $value;
                    unset($params[$key]);
                }
            }
            //from the code of autocomplete we get the address
            $geologyCriterion = []; //get info about the geology from autocomplete
            if (isset($params['geologyId'])) {
                $geologyCriterion = $this->estateModel->getGeologyCriterionFromAutocomplete(
                    $params['geologyType'], $params['geologyId']);
                unset($params['geologyId']);
                unset($params['geologyType']);
            }
            foreach ($geologyCriterion as $key => $value) {
                if ($key == 'districtId') {
                    if (!isset($params[$key])) {
                        $params[$key] = [];
                    }
                    $params[$key][] = $value;       //the districts and regions are in array 
                } else {
                    $params[$key] = $value;
                }
            }
            $count = $this->estateModel->countEstatesByParams($params);
            $this->payload->category = $this->estateModel->getCategoryById($params['categoryId']);
            $this->payload->estatesCount = $count;
            $this->sendPayload();
        }
    }
