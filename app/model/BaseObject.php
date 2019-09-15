<?php

namespace App\Model;

use Nette;
use Nette\Security\Passwords;
use Nette\Database;
use Nette\DI\Container;
use Nette\Database\Table\ActiveRow;
/**
 * Users management.
 */
class BaseObject 
{
    /** @var string $table **/
    public $table;
    
    /** @var Nette\Database\Context **/
	protected static $database;
    
    public function __construct(Nette\Database\Context $database)
	{
		self::$database = $database;
	}
    
    /**
	 * @param $name
	 * @return DibiConnection|dibi\Connection
	 */
	public function &__get($name) {
		if ($name === 'database') {
			return self::$database;
		} else {
			parent::__get($name);
		}
	}
    
    /**
     * Add new values to database
     * @param $values Associative array with column names and values
     * if id is set to NULL, it is insert action, otherwise it is replacement
     */
    public function save($values)
    {
        if (!isset($values['id'])) {
            $values['id'] = NULL;
        }
        if (isset($values['id'])) {
            $this->database->query("UPDATE $this->table SET", $values, 'WHERE id = ?', $values['id']);
            return $values['id'];
        } else {
            $this->database->query("INSERT INTO $this->table", $values);
            return $this->database->getInsertId();
        }
    }
    
    /**
     * Remove item from table
     * @param int $id
     */
    public function remove($id)
    {
        $this->database->table($this->table)->where('id', $id)->delete();
    }
    
    /**
     * Find item by id
     * @param int $id
     * @return ActiveRow
     */
    public function find($id)
    {
        return $this->database->table($this->table)->where('id = ?', $id);
    }


    /**
     * Find items by params
     * @param array $params Associative array with column names and values to search for
     * @return \Nette\Database\Table\Selection
     */
    public function findByParams($params)
    {
        $where = '';
        $values = '';
        foreach ($params as $key => $value) {
            $where = $key . ' = ? AND ';
            $values = $value . ', ';
        }
        $where = substr($where, 0, -5); //remove last ' AND ' from string
        $values = substr($values, 0, -2); //remove last ', ' from string
        $result = $this->database->table($this->table)->where($where, $values);
        return $result;
    }
    
    /**
     * Get values of columns
     * @var array $columns
     * @return Nette\Database\Table\Selection $result
     */
    public function findByColumns($columns)
    {
        return $this->database->table($this->table)->select(implode(', ', $columns));
    }
    
    /**
     * Get all columns in table
     * @return ObjectColection $res
     */
    public function findAll()
    {
        return $this->database->table($this->table);
    }
    
    /**
     * Fetch columns data to the form attributes
     * @param $object - Item id to get
     * @return array $values - Associative array with the keys which are form attributes
     */
    public function fetchDataToFormAttributes($object)
    {
        $values = [];
        //the keys of array is like column name but in camel case
        foreach ($object as $key => $val) {
            $attributeName = lcfirst(implode('', array_map('ucfirst', explode('_', $key))));
            $values[$attributeName] = $val;
        }
        return (object) $values;
    }

    /**
     * Set url to camelCase name
     * @param string $url
     */
    public function setUrlToCamelCaseName($url)
    {
        if (!empty($url)) {
            $name = lcfirst(implode('', array_map('ucfirst', explode('-', $url))));
            return $name;
        }
        return NULL;
    }
    
    /**
     * Set camelCase name to url
     * @param string $name
     */
    public function setCamelCaseNameToUrl($name)
    {
        if (!empty($name)) {
            $url = strtolower(preg_replace('/([A-Z])/', '-$1', $name));
            return $url;
        }
        return NULL;
    }

    /**
     * Set uppercase to underscore a lowercase
     * @param string $name
     */
    public function setCamelCaseToUnderScore($name)
    {
        if (!empty($name)) {
            $url = strtolower(preg_replace('/([A-Z])/', '_$1', $name));
            return $url;
        }
    }


    /**
     * Get the names of regions, districts, villages and streets by table 
     * @param string $ŧable
     * @return array $names
     */
    public function getNameList()
    {
        return $this->database->table($this->table)->select('name')->fetchPairs(NULL, 'name');
    }

    public function toArray($obj) {
        $array = (array) $obj;
        foreach ($array as &$attribute) {
            if (is_array($attribute) || is_object($attribute)) {
                $attribute = $this->toArray($attribute);
            }
        }
        return $array;
    }
}
