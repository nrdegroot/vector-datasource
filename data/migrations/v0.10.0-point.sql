UPDATE planet_osm_point
SET mz_poi_min_zoom = mz_calculate_min_zoom_pois(planet_osm_point.*)
WHERE
  amenity IN ('bbq', 'bicycle_repair_station', 'boat_rental', 'boat_storage', 'dive_centre', 'life_ring', 'picnic_table', 'shower', 'waste_disposal', 'watering_place', 'water_point', 'ranger_station', 'bicycle_rental', 'bicycle_parking') OR
  leisure IN ('water_park', 'beach_resort', 'summer_camp', 'dog_park', 'track', 'fishing', 'swimming_area', 'firepit') OR
  historic IN ('battlefield', 'fort', 'monument') OR
  tourism IN ('caravan_site', 'picnic_site' ) OR
  waterway IN ('dam') OR
  aerialway IN ('pylon') OR
  barrier IN ('cycle_barrier') OR
  emergency IN ('lifeguard_tower') OR
  shop IN ('boat_rental', 'fishing', 'hunting', 'outdoor', 'scuba_diving', 'gas', 'motorcycle', 'bicycle') OR
  tags->'rental' = 'boat' OR
  (shop = 'boat' AND tags->'rental' = 'yes') OR
  man_made IN ('beacon', 'cross', 'mineshaft', 'adit', 'petroleum_well', 'water_well', 'communications_tower', 'observatory', 'telescope', 'offshore_platform', 'water_tower', 'mast') OR
  "natural" IN ('saddle', 'dune', 'geyser', 'sinkhole', 'hot_spring', 'rock', 'stone', 'waterfall') OR
  "power" IN ('pole', 'tower') OR
  highway = 'trailhead' OR
  waterway = 'waterfall' OR
  tags->'whitewater' IN ('put_in;egress', 'put_in', 'egress', 'hazard', 'rapid') OR
  tags ? 'icn_ref' OR
  tags ? 'ncn_ref' OR
  tags ? 'rcn_ref' OR
  tags ? 'lcn_ref' OR
  tags ? 'iwn_ref' OR
  tags ? 'nwn_ref' OR
  tags ? 'rwn_ref' OR
  tags ? 'lwn_ref';

UPDATE planet_osm_point
  SET mz_places_min_zoom = mz_calculate_min_zoom_places(planet_osm_point.*)
  WHERE
    place IN ('continent');

UPDATE planet_osm_point
  SET mz_earth_min_zoom = mz_calculate_min_zoom_earth(planet_osm_point.*)
  WHERE mz_calculate_min_zoom_earth(planet_osm_point.*) IS NOT NULL;

UPDATE planet_osm_point
SET mz_water_min_zoom = mz_calculate_min_zoom_water(planet_osm_point.*)
WHERE mz_calculate_min_zoom_water(planet_osm_point.*) IS NOT NULL;

UPDATE planet_osm_point
  SET mz_places_min_zoom = mz_calculate_min_zoom_places(planet_osm_point.*)
  WHERE mz_calculate_min_zoom_places(planet_osm_point.*) IS NOT NULL;

UPDATE planet_osm_point
  SET mz_building_min_zoom = mz_calculate_min_zoom_buildings(planet_osm_point.*)
  WHERE mz_calculate_min_zoom_buildings(planet_osm_point.*) IS NOT NULL;

CREATE INDEX new_planet_osm_point_min_zoom_earth_9_index  ON planet_osm_point USING gist(way) WHERE mz_earth_min_zoom <= 9;
CREATE INDEX new_planet_osm_point_min_zoom_earth_12_index ON planet_osm_point USING gist(way) WHERE mz_earth_min_zoom <= 12;
CREATE INDEX new_planet_osm_point_min_zoom_earth_15_index ON planet_osm_point USING gist(way) WHERE mz_earth_min_zoom <= 15;

CREATE INDEX new_planet_osm_point_min_zoom_water_9_index ON planet_osm_point USING gist(way) WHERE mz_water_min_zoom <= 9;
CREATE INDEX new_planet_osm_point_min_zoom_water_12_index ON planet_osm_point USING gist(way) WHERE mz_water_min_zoom <= 12;
CREATE INDEX new_planet_osm_point_min_zoom_water_15_index ON planet_osm_point USING gist(way) WHERE mz_water_min_zoom <= 15;

CREATE INDEX new_planet_osm_point_min_zoom_places_9_index ON planet_osm_point USING gist(way) WHERE mz_places_min_zoom <= 9;
CREATE INDEX new_planet_osm_point_min_zoom_places_12_index ON planet_osm_point USING gist(way) WHERE mz_places_min_zoom <= 12;
CREATE INDEX new_planet_osm_point_min_zoom_places_15_index ON planet_osm_point USING gist(way) WHERE mz_places_min_zoom <= 15;

BEGIN;
  DROP INDEX IF EXISTS planet_osm_point_min_zoom_earth_9_index;
  DROP INDEX IF EXISTS planet_osm_point_min_zoom_earth_12_index;
  DROP INDEX IF EXISTS planet_osm_point_min_zoom_earth_15_index;

  ALTER INDEX new_planet_osm_point_min_zoom_earth_9_index RENAME TO planet_osm_point_min_zoom_earth_9_index;
  ALTER INDEX new_planet_osm_point_min_zoom_earth_12_index RENAME TO planet_osm_point_min_zoom_earth_12_index;
  ALTER INDEX new_planet_osm_point_min_zoom_earth_15_index RENAME TO planet_osm_point_min_zoom_earth_15_index;

  DROP INDEX IF EXISTS planet_osm_point_min_zoom_water_9_index;
  DROP INDEX IF EXISTS planet_osm_point_min_zoom_water_12_index;
  DROP INDEX IF EXISTS planet_osm_point_min_zoom_water_15_index;

  ALTER INDEX new_planet_osm_point_min_zoom_water_9_index RENAME TO planet_osm_point_min_zoom_water_9_index;
  ALTER INDEX new_planet_osm_point_min_zoom_water_12_index RENAME TO planet_osm_point_min_zoom_water_12_index;
  ALTER INDEX new_planet_osm_point_min_zoom_water_15_index RENAME TO planet_osm_point_min_zoom_water_15_index;

  DROP INDEX IF EXISTS planet_osm_point_min_zoom_places_9_index;
  DROP INDEX IF EXISTS planet_osm_point_min_zoom_places_12_index;
  DROP INDEX IF EXISTS planet_osm_point_min_zoom_places_15_index;

  ALTER INDEX new_planet_osm_point_min_zoom_places_9_index RENAME TO planet_osm_point_min_zoom_places_9_index;
  ALTER INDEX new_planet_osm_point_min_zoom_places_12_index RENAME TO planet_osm_point_min_zoom_places_12_index;
  ALTER INDEX new_planet_osm_point_min_zoom_places_15_index RENAME TO planet_osm_point_min_zoom_places_15_index;
COMMIT;