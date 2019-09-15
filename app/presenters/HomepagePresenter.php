<?php

namespace App\Presenters;
use Nette\Application\UI\Form;
use Nette\Http\SessionSection;
use Nette\Utils\Image;
use App\Forms\EstateFormFactory;
use App\Forms\ClientFormFactory;
use App\Model\Client;
use App\Model\Estate;
use App\Model\Geology;
use App\Model\Agent;
use App\Model\ImageStorage;
use App\Model\Company;
use App\Model\Helper;

class HomepagePresenter extends BasePresenter
{
  
    private $database;
    /** @var EstateFormFactory @inject **/
    private $estateFormFactory;

    /** @var Client **/
    public $clientModel;
    
    /** @var Estate @inject **/
    public $estateModel;
    
    /** @var Geology @inject **/
    public $geologyModel;

    /** @var Agent @inject **/
    public $agentModel;

    /** @var Company @inject **/
    public $companyModdel;

    /** @var ImageStorage @inject **/
    public $imageStorage;

    /** @var Helper @inject **/
    public $helper;

    /** @var bool **/
    private $edit = false;
	
	/** @var Form **/
	private $form;

    /** @var array **/
    private $streets;

    /** @var array **/
    private $districts;

    /** @var array **/
    private $villages;

    /** @var array **/
    private $regions;

    public function __construct(EstateFormFactory $estateFormFactory,
                    \Nette\Database\Context $database) {
        $this->estateFormFactory = $estateFormFactory;
        $this->database = $database;
    }
    public function renderDefault($idEstate = NULL)
    {
		$values = $this->getHttpRequest()->getPost();
		if (!isset($this->form)) {
			$this->form = $this['estateForm'];
		} 
		if (!empty($values) && isset($values['category'])) {
			$types = $this->estateModel->getTypes($values['category'], $values['orderType']);
			            $this->form['types']->setItems($types);

		}
        if (!empty($values)) {
			$this->form->setDefaults($values);
		} 
        $this->form->setAction($this->link('default'));
       
        $this->template->form = $this->form;
        $this->template->edit = $this->edit;
        $this->template->idEstate = $idEstate;
        $parentManifolds = $this->estateModel->getParentManifolds()->fetchAll();
        $pManifolds = array();
        $i = 0;
        foreach ($parentManifolds as $manifold) {
            $pManifolds[$i]['id'] = $manifold->id;
            $pManifolds[$i]['name'] = $this->estateModel->setUrlToCamelCaseName($manifold->url);
            $pManifolds[$i]['type'] = $manifold->type;
            $i++;
        }
        $this->template->parentManifolds = $pManifolds;
        $this->template->manifoldsByCat = $this->estateFormFactory->manifoldsByCat;

        if ($this->isAjax()) {
            $this->redrawControl('estateInfos');
        } 
    }

    public function handleGetLocation($latitude, $longitude) 
    {
        $locations = $this->geologyModel->getGeoLocationsByGps($latitude, $longitude);
        foreach ($locations as $location) {
            $locationType = $location->getLocationType();
            $this['estateForm']['regionId']->setValue($location->getPolitical());
            $this['estateForm']['districtId']->setValue($location->getLocality());
            $this['estateForm']['villageId']->setValue($location->getSubLocality());
            $this['estateForm']['streetId']->setValue($location->getStreetName());
        }
        $this->redrawControl('estateInfos');
        $this->redrawControl('location');
        //$locationType
    }
      
    public function createComponentEstateForm() 
    {

        $form = $this->estateFormFactory->create();
        $form->onSubmit[] = function(Form $form) {
            $this->flashMessage('Bạn đã nhập thành công bất động sản.', 'success');
            $this->redirect('showList');
        };
        return $form;
    }
        
    public function actionShowList()
    {
        $estates = $this->estateModel->findAll();
        $this->template->estates = $estates;
    }
   
    public function actionEdit($idEstate)
    {
        $this->edit = TRUE;
        $estate = $this->estateModel->find($idEstate)->fetch();

        if ($estate) {
            $estateData = $this->estateModel->fetchDataToFormAttributes($estate);
        } 
        $dateAttributes = ['dateOfMoving', 'projectDateOfFinish', 'projectDateOfSale'];
        foreach ($dateAttributes as $attribute) {
            $estateData->{$attribute} = (!is_null($estateData->{$attribute})) ? 
            $estateData->{$attribute}->format('d/m/Y') : null;
        }
        $estateManifoldsData = $this->estateModel->getEstateManifoldsData($idEstate)->fetchAll();
        $manifoldsData = array();
        foreach ($estateManifoldsData as $data) {
            $newKey = $this->estateModel->setUrlToCamelCaseName($data->url);
            if ($data->type == 'checkbox-list') {
                if (!isset($manifoldsData[$newKey])) {
                    $manifoldsData[$newKey] = array();
                    $manifoldsData[$newKey][] = $data->value;
                } else {
                    $manifoldsData[$newKey][] = $data->value;
                }
            } else {
                $manifoldsData[$newKey] = $data->value;
            }
        }
        $this['estateForm']->setDefaults($manifoldsData);
        
        $districts = $this->geologyModel->getDistrictsByRegion($estateData->regionId)->fetchPairs('id', 'name');
        $this['estateForm']['districtId']->setItems($districts);
        $villages = $this->geologyModel->getVillagesByDistrict($estateData->districtId)
                        ->fetchPairs('id', 'name');
        $this['estateForm']['villageId']->setItems($villages);
        if ($estateData->villageId) {
            $streets = $this->geologyModel->getStreetsByVillage($estateData->villageId)->fetchPairs('id', 'name');
            $this['estateForm']['streetId']->setItems($streets);
        }

        $dispositions = $this->estateModel->getHouseDispositions($estateData->orderType);
        $types = $this->estateModel->getTypes($estateData->categoryId);
        $this['estateForm']['type']->setItems($types);
        $this['estateForm']['type']->setItems($types);

        $this['estateForm']->setDefaults($this->estateModel->toArray($estateData));
        $this['estateForm']->setDefaults([
            'regionId' => $estateData->regionId,
            'districtId' => $estateData->districtId,
            'villageId' => $estateData->villageId,
            'streetId' => $estateData->streetId,
        ]);

        $images = $this->helper->readImages("../www/images/" . $idEstate);
      
        $this->template->form = $this['estateForm'];
       
        $this->template->edit = $this->edit;
        $this->template->estate = $estateData;

        $this->template->images = $images;
        $this->setView('default', array('idEstate' => $idEstate));
        if ($this->isAjax()) {
            $this->redrawControl('estateInfos');
            $this->redrawcontrol('imagesContainer');

        } 
   
    }
   
   public function handleImport() 
   {
        $set = [];
        $i = 0;
        $newFilePath =  "C:\Users\uživatel\Dokumenty\prag_distr.csv";
        if (($handle = fopen($newFilePath, "r")) !== FALSE) {
            $sqlInit = "INSERT INTO prag_district_village_street (prag_district_code,
                    prag_village_part_code, prag_street_code) VALUES ";
            while (($data = fgetcsv($handle, 1000, ",")) !== FALSE) {
                if ($data[2] == '') {
                    $data[2] = 0;
                }
                $set[] = implode(',', [$data[0], $data[1], $data[2]]);
                if ($i == 1000) {
                    $sql = $sqlInit;
                    $sql .= '(' . implode('), (', $set) . ')';
                    $this->database->query($sql);

                    $i = 0;
                    $set = [];
                    continue;
                }
                $i++;
            }
            fclose($handle);
        }
        $this->terminate();
    }

    public function handleFetchTypes()
    {
        $values = $this->getHttpRequest()->getPost();
        if ($values['categoryId'] == 2) {
            $dispositions = $this->estateModel->getHouseDispositions($values['orderType']);
        }
        $types = $this->estateModel->getTypes($values['categoryId']);
		$this->form = $this['estateForm'];
        if (isset($dispositions)) {
            $this->form['houseDisposition']->setItems($dispositions);
            $this->payload->dispositions = $this->form['houseDisposition']->getControl()->getHtml();
        }
        if ($types) {
            $this->form['type']->setItems($types);
            $this->payload->types = $this->form['type']->getControl()->getHtml();
        }
        $this->sendPayload();
    }

    public function handleSelectFromAutocomplete($id, $object) 
    {
        $this['estateForm'][$object]->getControlPrototype()->setAttribute('id-' . $object, $id);
        $this->terminate();
    }

    public function actionGetDistrictsByRegion($idRegion)
    {
        $districts = $this->geologyModel->getDistrictsByRegion($idRegion)->fetchPairs('id', 'name');
        ;
        $districts = array('0' => "") + $districts;

        $this['estateForm']['districtId']->setItems($districts);
        echo json_encode($districts);
        $this->terminate();
    }
    

    public function actionGetVillagesByDistrict($idDistrict)
    {
        $villages = $this->geologyModel->getVillagesByDistrict($idDistrict)->fetchPairs('id', 'name');
        $villages = array('0' => "") + $villages;
        $this['estateForm']['villageId']->setItems($villages);
        echo json_encode($villages);
        $this->terminate();
    }

    public function actionGetVillagePartsByVillage($idVillage)
    {
        $res = $this->geologyModel->getVillagePartsByVillage($idVillage);
        $villageParts = $this->geologyModel->getVillagePartsByVillage($idVillage)->fetchPairs('id', 'name');
        $villageParts = array('0' => "") + $villageParts;

        $this['estateForm']['villagePartId']->setItems($villageParts);
        $this['estateForm']['streetId']->setItems($villageParts);
        $streets = $this->geologyModel->getStreetsByVillage($idVillage)->fetchPairs('id', 'name');
        $streets = array('0' => "") + $streets;
        $infos = array(
            'villageParts' => $villageParts,
            'streets' => $streets,
        );
        
        echo json_encode($infos);
        $this->terminate();
    }

    public function actionGetStreetsByVillage($idVillage) 
    {
        $streets = $this->geologyModel->getStreetsByVillage($idVillage)->fetchPairs('id', 'name');
        $streets = array('0' => "") + $streets;
        $this['estateForm']['streetId']->setItems($streets);
        echo json_encode($streets);
        $this->terminate();
    }

    public function handleDeleteImage($idEstate, $idImage) 
    {
        $imageEstateDir = IMAGE_DIR . '/' . $idEstate;
        $imageName = $idEstate . '_' . $idImage;
        $images = $this->helper->getAllFilenames($imageEstateDir);
        foreach ($images as $image) {
            if (preg_match('/' . $imageName . '\.[jpg|jpeg|png|gif]/', $image)) {
                unlink($imageEstateDir . '/' . $image);
            } 
        }
        $countImages = $this->helper->countFiles($imageEstateDir);
        $images = $this->helper->getAllFilenames($imageEstateDir);
        
        //we set the order of images again after change
        for ($i = 1; $i <= $countImages; $i++) {
            $newName = preg_replace('/_\d+\./', '_' . $i . '.', $imageEstateDir . '/' . $images[$i-1]);
            rename($imageEstateDir . '/' . $images[$i-1], $newName);             
        }
        $this->template->imagesCount = $countImages;
        $this->template->imageChanged = true;
        $this->redrawControl('estateInfos');
        $this->redrawcontrol('imagesContainer');
    }

    public function handleSortImages($idEstate, array $images)
    {
        $dirs = [];
        $dirs[] = IMAGE_DIR . '/' . $idEstate;
        $dirs[] = IMAGE_DIR . '/thumbs/' . $idEstate;
        foreach ($images as $imageName => $pos) {
            if (!strstr($imageName, '_' . $pos . '.')) {  //an image has the position changes 
                foreach ($dirs as $dir) {
                    //swap two file names, we use temporary name for swapping
                    $prevName =  $dir . '/' . $imageName;
                    $tmpName = $dir . '/' . 'tmp_' . $imageName;
                    $newName = preg_replace('/_\d+\./', '_' . $pos . '.', $prevName);
                    rename($newName, $tmpName); //first we change the second file name to temp 
                    rename($prevName, $newName); //change name of first file to second file
                    rename($tmpName, $prevName); //change name of second file to name of first file
                }

                break; //end the cyclus
            }
        }
        $images = $this->helper->readImages($dirs[0]);
        $this->template->images = $images;
        $this->template->imageChanged = true;
        $this->redrawControl('estateInfos');
        $this->redrawcontrol('imagesContainer');
    }
}
