<?php
namespace App\Model;
use Nette;
use Geoidr\Query\GeoidQuery;
use Geoidr\ProviderAggregator;
use Geoidr\Provider\Chain\Chain;
use Geoidr\Provider\FreeGeoIp\FreeGeoIp;
use Geoidr\Provider\HostIp\HostIp;
use Geoidr\Provider\GoogleMaps\GoogleMaps;
use Buzz\Client\FileGetContents;
use Nyholm\Psr7\Factory\Psr17Factory;
use Geoidr\StatefulGeoidr;
use Geoidr\Query\ReverseQuery;


class Geology extends BaseObject
{
   
	private $table_regions = 'regions';
	private $table_districts = 'districts';
	private $table_villages = 'villages';
	private $table_streets = 'streets';
	private $districtsOrdered = array();
	private $villages = array();
    private $pragueDistrictIds = array();
	private $pragueVillagePartIds = array();

	public function __construct(Nette\Database\Context $database)
	{
        parent::__construct($database);
        $this->villages = $this->getVillages();
        $this->districtsOrdered = $this->getDistrictsOrdered();
        $this->getPragueDistrictIds();
        $this->getPragueVillagesPartIds();
	}
    
    /**
     * @param string $table - Values are 'regions', 'districts', 'villages', 'streets'
     */
    public function setTable($table)
    {
        $this->table = $table;
        return $this;
    }
	
	/**
	 * Get the regions
	 */
	public function getRegions()
	{
		return $this->database->table('regions');
	}
	
	/**
	 * Get the districts
	 */
	public function getDistricts()
	{
		return $this->database->table('districts');
	}

    public function getPragueDistrictIds() //for Prague 1 to Prague 10
    {
        $sql = "SELECT id FROM districts WHERE name LIKE ?";
        $res = $this->database->query($sql, '%Praha %')->fetchAll();
        foreach ($res as $row) {
            $this->pragueDistrictIds[] = $row->id;
        }
    }

	/**
	 * Get the districts by region
	 */
	public function getDistrictsByRegion($idRegion)
	{
		return $this->getDistricts()->where('region_id = ?', $idRegion);
	}
	
	/*
	 * Get the villages
	 */
	public function getVillages()
	{
		return $this->database->table('villages');
	}

    public function getPragueVillagesPartIds()
    {
        $sql = "SELECT DISTINCT id_village_part " . 
            "FROM prag_district_village_street";
        $res = $this->database->query($sql);
        foreach ($res as $row) {
            $this->pragueVillagePartIds[] = $row->id_village_part;
        }
    }

	/**
	 * Get the villages by district
	 */
	public function getVillagesByDistrict($idDistrict)
	{
        //if idDistrict is in the array of prague district ids, we get the village parts
        if (in_array($idDistrict, $this->pragueDistrictIds)){
            $sql = "SELECT vp.* FROM village_parts vp " . 
                "JOIN prag_district_village_street pgvs " .
                "ON vp.id = pgvs.id_village_part WHERE pgvs.id_prague_district = ?";
            $res = $this->database->query($sql, $idDistrict);
            return $res;
        }
		return $this->getVillages()->where('district_id = ?', $idDistrict);
	}
	
	/*
	 * Get the village parts
	 */
	public function getVillageParts()
	{
		return $this->database->table('village_parts');
	}

	/*
	 * Get the villages
	 */
	public function getStreets()
	{
		return $this->database->table('streets');
	}

	/**
	 * @param int $idVillage 
	 * Get the village parts by village
	 **/
	public function getVillagePartsByVillage($idVillage)
	{
        if (!in_array($idVillage, $this->pragueVillagePartIds)) {
            return $this->getVillageParts()->where('village_id = ?', $idVillage);
        }
        return $this->getVillageParts()->where('id = ?', $idVillage);
	}

	/**
	 * Get the streets by village
	 */
	public function getStreetsByVillage($idVillage)
	{
        if (in_array($idVillage, $this->pragueVillagePartIds)) {
            $sql = "SELECT s.* FROM streets s " . 
                "JOIN prag_district_village_street pdvs " . 
                "ON s.id = pdvs.id_street WHERE pdvs.id_village_part = ? " . 
                "ORDER BY s.name ASC";
            return $res = $this->database->query($sql, $idVillage);
        }
		return $this->getStreets()->where('village_id = ?', $idVillage);
	}

	/*
	 * Get region by id
	 */
	public function getRegionById($id)
	{
		return $this->database->table('regions')->get($id);
	}

	/**
	 * Get the address of estate by gpsx and gpsy, maybe without street?
	 * @param float $latitude
	 * @param float $longitude
	 * @return 
	 */
	public function getGeoLocationsByGps($latitude, $longitude)
	{
		$apiKey = 'AIzaSyAHrVZzIx_6cuYF6GYFw7shWk0hY9JCADo';

		//$geoidr = new ProviderAggregator();
		$client = new FileGetContents(new Psr17Factory());
		/*$chain = new Chain([
			new FreeGeoIp($client),
			new HostIp($client),
			//new GoogleMaps($client, 'CZECH'),
		]);

		$geoidr->registerProvider($chain);*/
		$client = new FileGetContents(new Psr17Factory());
		$provider = new GoogleMaps($client, 'cz', $apiKey);
		$geoidr = new StatefulGeoidr($provider, 'cz');

		$result = $geoidr->reverseQuery(ReverseQuery::fromCoordinates($latitude, $longitude));
		return $result;
	}

/**
     * Get infos about the streets for filtering by params
     */
    public function getStreetsDataForSearching()
    {
        $streetData = array();
        $streets = array();
        $streetsRes = $this->database->table('streets');
        $villageInfos = $this->getDistrictsAndRegionsByVillages();
        foreach ($this->villages as $village) {
            $streetData[$village->id] = array();
            $streetData[$village->id][0] = $village->name;
            $streetData[$village->id][1] = $villageInfos[$village->id][0];
            $streetData[$village->id][2] = $villageInfos[$village->id][1];
        }
        $i = 0;
        foreach ($streetsRes as $street) {
            $streets[$i] = [];
            $streets[$i]['type'] = 'street';
            if (!isset($streetData[$street->village_id][0])) {
            	die(var_dump($street->village_id));
            }
            $streets[$i]['label'] = "phố " . $street->name . ', quận (huyện) ' . $streetData[$street->village_id][0]
                        . ", tỉnh (thành phố) " . $streetData[$street->village_id][1]
                        . ", vùng " . $streetData[$street->village_id][2];      
            $streets[$i]['value'] = $street->id; 
            $i++;
        }

        return $streets;
    }

    private function getDistrictsAndRegionsByVillages()
    {
    	$villageInfos = [];
       
    	$sql = "SELECT vi.id as village_id, di.name as district_name," 
    		. "re.name as region_name FROM villages vi"
			. " JOIN districts di ON vi.district_id = di.id"
			. " JOIN regions re ON di.region_id = re.id";
		$result = $this->database->query($sql)->fetchAll();
		foreach ($result as $res) {
			$villageInfos[$res->village_id][0] = $res->district_name;
			$villageInfos[$res->village_id][1] = $res->region_name;
		}
		return $villageInfos;

    }
    /**
     * Get infos about the villages for filtering by params
     */
    public function getVillagesDataForSearching()
    {
        $villageData = array();
        $villages = array();
    	$villageInfos = $this->getDistrictsAndRegionsByVillages();
        $i = 0;
        foreach($this->villages as $village) {
            $villageData[$i] = array();
            $villageData[$i]['name'] = $village->name;
            $villageData[$i]['id'] = $village->id;
            $villageData[$i]['district_name'] = $villageInfos[$village->id][0];
            $villageData[$i]['region_name'] = $villageInfos[$village->id][1];
            $i++;
        }

        $i = 0;
        foreach ($villageData as $data) {
            $villages[$i] = [];
            $villages[$i]['type'] = 'village';
            $villages[$i]['label'] = "quận (huyện) " . $data['name'] . ", tỉnh (thành phố) " . $data['district_name']
                        . ", vùng " . $data['region_name'];
            $villages[$i]['value'] = $data['id'];
            $i++;
        }

        return $villages;
    }

    /**
     * Get infos about the village parts for filtering by params
     */
    public function getVillagePartsDataForSearching()
    {
        $villagePartData = array();
        $villageParts = array();
        $villagePartsRes = $this->database->table('village_parts');
        $villageInfos = $this->getDistrictsAndRegionsByVillages();
        foreach ($this->villages as $village) {
            $villagePartData[$village->id] = array();
            $villagePartData[$village->id][0] = $village->name;
            $villagePartData[$village->id][1] = $villageInfos[$village->id][0];
            $villagePartData[$village->id][2] = $villageInfos[$village->id][1];
        }

        $i = 0;
        foreach ($villagePartsRes as $villagePart) {
            $villageParts[$i]  = [];
            $villageParts[$i]['type'] = 'villagePart';
            $villageParts[$i]['label'] = "thị trấn " . $villagePart->name 
                    . ', quận (huyện) ' . $villagePartData[$villagePart->village_id][0]
                    . ", tỉnh (thành phố) " . $villagePartData[$villagePart->village_id][1]
                    . ", vùng " . $villagePartData[$villagePart->village_id][2];
            $villageParts[$i]['value'] = $villagePart->id;
            $i++;
        }

        return $villageParts;
    }

    /**
     * Get infos about districts for filtering by params
     */
    public function getDistrictsDataForSearching()
    {
        $districtData = array();
        $districts = array();
        
        $i = 0;
        foreach ($this->districtsOrdered as $district) {
            $districtData[$i] = array();
            $districtData[$i]['name'] = $district->name;
            $districtData[$i]['id'] = $district->id;
            $districtData[$i]['region_name'] = $district->ref('regions', 'region_id')->name;
            $i++;
        }

        $i = 0;
        foreach ($districtData as $data) {
            $districts[$i] = [];
            $districts[$i]['type'] = 'district';
            $districts[$i]['label'] = "tỉnh (thành phố) " . $data['name'] . ", vùng " . $data['region_name'];
            $districts[$i]['value'] = $data['id'];
            $i++;
        }

        return $districts;
    }

    /**
     * Get ordered districts for filtering by params
     */
    public function getOrderedDistrictsForSearching()
    {
    	$i = 0;
        $districtsOrdered = array();  //list used for population comparasion among districts
        foreach ($this->districtsOrdered as $district) {
            $districtsOrdered[$i] = $district->name;  
            $i++;
        }

        return $districtsOrdered;
    }

	private function getDistrictsOrdered()
	{
		return $districtsRes = $this->database->table('districts')->order('population DESC');
	}
}

