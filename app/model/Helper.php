<?php

namespace App\Model;
use Nette\Utils\Image;
class Helper {
	public function countFiles($dir) 
    {
        $this->createIfNotExist($dir);
        $i = 0; 
        $handle = \opendir($dir);
        if ($handle) {
            while (($file = \readdir($handle)) !== false){
                if (!in_array($file, array('.', '..')) && !is_dir($dir . '/' . $file)) {
                    $i++;
                }
            }
        }
        return $i;
    }

    public function readImages($dir)
    {
        $this->createIfNotExist($dir);
        $images = [];
        $handle = \opendir($dir);
        if ($handle) {
            while (($file = \readdir($handle)) !== false){
                if (!in_array($file, array('.', '..')) && !is_dir($dir . '/' . $file)) {
                    preg_match('/.+_(\d+)\.*/', $file, $matches);
                    $number = $matches[1];
                    $images[$number]['name'] = $file;
                    $images[$number]['data'] = Image::fromFile($dir . '/' . $file);
                }
            }
        }
        return $images;
    }

    private function createIfNotExist($dir)
    {
        if (!file_exists($dir)) {
            mkdir($dir, 0777, TRUE);
        }
    }
    public function getAllFilenames($dir) 
    {
        return array_values(array_diff(scandir($dir), array('.', '..')));
    }
}