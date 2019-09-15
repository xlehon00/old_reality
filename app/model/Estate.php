<?php
namespace App\Model;
use Nette;
use App\Model\Geology;

class Estate extends BaseObject
{
    protected $table_dispositions = 'house_dispositions';
    protected $table_types = 'estate_types';
    protected $table_deal_units = 'estate_deal_units';
    protected $table_categories = 'categories';
	protected $table_states = 'estate_states';
    protected $table_conditions = 'estate_conditions';
    protected $table_options = 'manifolds';
    protected $table_manifold_relation = 'estates_manifolds';

	private $geologyModel;
    private $regionTable = 'regions';
    private $districtTable = 'districts';
    private $villageTable = 'villages';
    private $villagePartsTable = 'village_parts';
    private $streetTable = 'streets';
    private $projectTable = 'projects';
    private $currencies = ['1' => 'CZK', '2' => 'EUR', '3' => 'USD'];
    private $criterions = array();


    public function __construct(Nette\Database\Context $database, Geology $geologyModel)
	{
        parent::__construct($database);
        $this->table = 'estates';
        $this->geologyModel = $geologyModel;
	}
    
    public function getHouseDispositions($orderType = 1)
    {
        return $this->database->table($this->table_dispositions)->fetchPairs('id', 'name');
    }
    
	/**
	 * Get types of estate by category id
	 * @return types
	 */
    public function getTypes($categoryId, $orderType = 1) 
    {
        return $this->database->table($this->table_types)->where('category_id = ?', $categoryId)
                    ->fetchPairs('id', 'name');
    }
	
    /**
     * Get order types
     */
    public function getOrderTypes()
    {
        return array('1' => 'Bán', '2' => 'Cho thuê', '3' => 'Được thu hồi và đấu giá');
    }

	/**
	 * 
	 * @return type
	 */
	public function getStates()
	{
		return $this->database->table($this->table_states)->fetchPairs('id', 'value');
	}

	/**
	 * Get all categories
	 * @return categories
	 */
	public function getCategories()
    {
        return $this->database->table($this->table_categories)->fetchPairs('id', 'name');
    }

    /**
     * Get manifolds by category
     * @param int $categoryId
     */
    public function getManifoldsOfCategory($categoryId)
    {
        return $this->database->table($this->table_options)->where('category_id = ?', $categoryId)->fetchAll();
    }
    
	/**
	 * @param $id
	 */
	public function getCategoryById($id)
	{
		return $this->database->table($this->table_categories)->get($id);
	}


	/**
     * Get deal units for sale or for lease
     * @var int $orderType
     */
    public function getDealUnits($orderType = NULL)
    {
        if ($orderType) {
            return $this->database
                ->table($this->table_deal_units)
                ->select('*')
                ->where('id_order_type = ?', $orderType);
        } else {
            return $this->database->table($this->table_deal_units);
        }
    }
    
    /**
     * Search for the estates by given criterions
     * @param array $criterions
     * @return Selection|int
     */
    public function searchByCriterions($criterions, $sql = null, $counting = false)
    {
        if (!$sql) {
            $sql = $this->findBySql();
        } 
     
        $i = 0;
        $conditions = '';
        $params = array();          //array to save params of where condition
        foreach ($criterions as $key => $value) {
            $key = $this->setCamelCaseToUnderScore($key);
            if ($key != 'manifolds' && is_array($value) && !empty($value)) {
                $conditions .= " AND e.{$key} IN (?)";
                $params[] = $value;
                $i++;
            } elseif (($pos = strpos($key, '_from')) !== false && $value != '') {
                $attributeName = substr($key, 0, $pos);
                $conditions .= " AND e.{$attributeName} >= ?";
                $params[] = intval($value);  //change value to int for comparation
                $i++;
            } elseif ((($pos = strpos($key, '_to')) == (strlen($key) - 3)) && $value != '') {
                $attributeName = substr($key, 0, $pos);
                $conditions .= " AND e.{$attributeName} <= ?";
                $params[] = intval($value);
                $i++;
            } elseif ($key == 'time_since_adding_ad') {
                if ($value != 0) {
                    $conditions .= " AND DATEDIFF(NOW(), created_at) < ?";
                    $params[] = $value;
                } 
            } elseif ($key == 'manifolds' && !empty($value)) { //value is array
                $sql .= " LEFT JOIN estates_manifolds em ON e.id = em.id_estate" . 
                        " LEFT JOIN manifolds m ON em.id_manifold = m.id";
                $this->addManifoldValuesToConditions($value, $criterions, $conditions, $params);
            } elseif ($value != '') {
                $conditions .= " AND e.{$key} = ?";
                $params[] = $value;
                $i++;
            }
            
        }
        
        $conditions = ' WHERE ' . substr($conditions, 5);
        if (!empty($criterions)) {
            $res = $this->database->queryArgs($sql . $conditions, $params)->fetchAll();
        } else {
            $res = $this->database->query($sql)->fetchAll();
        }

        $estateData = array();
        if (!$counting) {
            foreach ($res as $estate) {
                $estateData[] = $this->fetchDataToFormAttributes($estate);
            }
            return $estateData;
        } else {
            return $res;
        }
    }

    /**
     * Manifolds which are in same group will be delimited by 'OR' in the sql command
     */
    private function groupManifoldsForSearch($categoryId)
    {
        $groupIndexes = $this->database->query('SELECT DISTINCT group_index 
            from manifolds WHERE category_id = ?', $categoryId)->fetchAll();
        $groups = [];
        foreach ($groupIndexes as $index) {
            //$groups[$index->group_index] = [];
            $manifolds = $this->database->query('SELECT id 
            from manifolds WHERE category_id = ? AND group_index = ?', 
                    $categoryId, $index->group_index)->fetchAll();
            foreach ($manifolds as $manifoldId) {
                $groups[$index->group_index][] = $manifoldId->id;
            }
        }
        return $groups;
    }

    private function addManifoldValuesToConditions($value, $criterions, &$conditions, &$params)
    {
        $manifoldsGroups = $this->groupManifoldsForSearch($criterions['categoryId']);
        $groups = [];
        foreach ($value as $val) {
            foreach ($manifoldsGroups as $key => $maniGroup) {
                if (in_array($val, $maniGroup)) {
                    $groups[$key][] = $val; //if id of manifold is in the array
                }
            }
        }
        foreach ($groups as $group) {
            $conditions .= ' AND (';
            foreach ($group as $val) {
                $conditions .= 'em.value = ? OR ';
                $params[] = $val;
            }
            $conditions = substr($conditions, 0, -4) . ')'; 
        }
    }
    /**
     * Get estate currency
     * @return CZK, EUR or USD
     **/
    public function getCurrencies()
    {
        return $this->currencies;
    }
  
    /**
     * Find detail view of estate
     */
    public function findBySql()
    {
        $sql = "SELECT e.*, r.name AS region, " . 
                "d.name AS district, v.name AS village, " . 
                "s.name AS street " . 
                "FROM estates e LEFT JOIN regions r ON r.id = e.region_id " . 
                "LEFT JOIN districts d ON d.id = e.district_id " . 
                "LEFT JOIN villages v ON v.id = e.village_id " . 
                "LEFT JOIN streets s ON s.id = e.street_id";
        return $sql;
    }

    /**
     * Find detail of the estate by id
     * @param int $id
     */
    public function findById($id)
    {
        return $this->database->query($this->findBySql() . " WHERE e.id = ?", $id);
    }

    /**
     * Get the manifold by its url
     * @param string $url
     */
    public function getManifoldByUrl($url)
    {
        return $this->database->table($this->table_options)->where('url = ?', $url);
    }

    /**
     * Get the manifolds with their parent id
     * @param int $parentId
     */
    public function getManifoldOptionsByParent($parentId)
    {
        return $this->database->table($this->table_options)->where('parent_id = ?', $parentId);     
    }

    /**
     * Get the manifolds, which are parent
     */
    public function getParentManifolds()
    {
        return $this->database->table($this->table_options)->where('is_parent = ? AND category_id IS NULL', 1);
    }

    /**
     * Get all manifolds for specific category or general manifolds
     * Manifolds must not be parent of others
     **/
    public function getAvailableManifolds($idCategory)
    {
        return $this->database->table($this->table_options)->where(
            'category_id IS NULL OR category_id = ?', $idCategory);
    }


    /**
     * Save the values of manifold to relation table of the estate and the manifolds
     * Attribute name is in camelCase
     * @param array $values
     * @param int $idEstate
     **/
    public function saveManifoldValuesOfEstate($values, $idEstate) 
    {
        $rows = array();
        $manifolds = $this->database->table($this->table_options)->fetchAll();
        
        foreach ($manifolds as $manifold) {        
            if (array_key_exists($manifold->url, $values)) {
                if (is_array($values[$manifold->url])) {     //the manifold has multivalue
                    foreach ($values[$manifold->url] as $val) {
                        $row = [
                            'id_estate' => $idEstate,
                            'id_manifold' => $manifold->id,
                            'id_manifold_parent' => $manifold->parent_id,
                            'value' => $val,
                        ];
                        $rows[] = $row;
                    }
                } else {
                    $row = [
                        'id_estate' => $idEstate,
                        'id_manifold' => $manifold->id,
                        'id_manifold_parent' => $manifold->parent_id,
                        'value' => $values[$manifold->url],
                    ];
                    $rows[] = $row;
                }
            }
        }
        //\Tracy\Debugger::fireLog($rows); die;
        foreach ($rows as $row) {
            $this->database->query("DELETE FROM $this->table_manifold_relation WHERE id_estate = ? " . 
                                    "AND id_manifold = ?", $row['id_estate'], $row['id_manifold']);
        }
        if (!empty($rows)) {
            $this->database->query("INSERT INTO $this->table_manifold_relation", $rows);
        }
    }

    /**
     * Get the estate manifold data from relation table
     * @param int $idEstate
     **/
    public function getEstateManifoldsData($idEstate)
    {
        $sql = 'SELECT em.*, m.name, m.url, m.type FROM estates_manifolds em LEFT JOIN manifolds m ' .
                'ON em.id_manifold = m.id WHERE em.id_estate = ?';
        return $this->database->query($sql, $idEstate);
    }

    /**
     * Get geology by code of the region, the district or the street
     * @param string $type
     * @param int $id
     */         
    public function getGeologyCriterionFromAutocomplete($type, $id) 
    {
        $criterion = [];
        switch ($type) {
            case 'district':
                $criterion['districtId'] = $id;
                break;
            case 'village':
                $criterion['villageId'] = $id;
                break;
            case 'villagePart':
                $criterion['villagePartId'] = $id;
                break;
            case 'street':
                $criterion['streetId'] = $id;
                break;
            default:
        }

        return $criterion;
    } 

    public function getCriterions()
    {
        return $this->criterions;
    }

    public function setCriterions($criterions)
    {
        $this->criterions = $criterions;
    }

    public function countEstatesByParams($criterions = null)
    {
        $sql = "SELECT COUNT(*) AS estatesCount " .
                "FROM estates e LEFT JOIN regions r ON r.id = e.region_id " . 
                "LEFT JOIN districts d ON d.id = e.district_id " . 
                "LEFT JOIN villages v ON v.id = e.village_id " . 
                "LEFT JOIN streets s ON s.id = e.street_id";
        if (!$criterions) {
            $criterions = $this->criterions;
        }
        $count = $this->searchByCriterions($criterions, $sql, true);
        return $count[0]['estatesCount'];
    }

    public function getAddingManifoldInfosByCategory($categoryId)
    {
        $sql = 'SELECT id, name FROM manifolds WHERE category_id = ?';
        return $this->database->query($sql, $categoryId)->fetchPairs('id', 'name');
    }

    public function isExists($id, $table = null) //id of the estate or the project 
    {
        if (!isset($table)) {
            $table = $this->table;
        }
        return $this->database->query("SELECT 1 FROM $table WHERE id = ?", $id)->fetch();
    }
}
