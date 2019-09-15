<?php
namespace App\Presenters;
use App\Model\Estate;
/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
class EstatesListPresenter extends BasePresenter
{
    /**
     * @var Estate @inject
     */
    public $estateModel;

    /* @vaer Geology @inject */
    public $geologyModel;
    
	public function renderDefault()
	{
        $criterions = $this->getHttpRequest()->getPost();
        $estates = $this->estateModel->searchByCriterions($criterions);
        $this->template->estates = $estates;
        $this->template->currencies = $this->estateModel->getCurrencies();
        $this->template->dealUnits = $this->estateModel->getDealUnits()->fetchPairs('id', 'name');
        
    }
        
}
