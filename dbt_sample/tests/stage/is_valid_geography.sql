SELECT *
FROM {{ ref('stg_neighborhoods') }}
WHERE NOT ST_ISVALID(the_geom)