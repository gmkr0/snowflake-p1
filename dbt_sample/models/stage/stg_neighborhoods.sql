SELECT
    TO_GEOMETRY(the_geom) AS the_geom,
    BoroCode::string(255) AS BoroCode,
    BoroName::string(255) AS BoroName,
    CountyFIPS::string(255) AS CountyFIPS,
    NTA2020::string(255) AS NTA2020,
    NTAName::string(255) AS NTAName,
    NTAAbbrev::string(255) AS NTAAbbrev,
    NTAType::string(255) AS NTAType,
    CDTA2020::string(255) AS CDTA2020,
    CDTAName::string(255) AS CDTAName,
    Shape_Leng::integer AS Shape_Leng,
    Shape_Area::float AS Shape_Area
FROM {{ ref('neighborhoods') }}