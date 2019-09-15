<?php
namespace App\Model;
use Nette\SmartObject;
class ImageStorage
{
	/** @var string $dir **/
    private $dir;

    public function __construct($dir = '')
    {
        $this->dir = $dir;
    }

    /**
     * @param string $file
     * @param FileUpload $image 
     **/
    public function save($file, $image)
    {
       $image->move($this->dir . '/' . $file);
    }

    public function getDir()
    {
    	return $this->dir;
    }    
}