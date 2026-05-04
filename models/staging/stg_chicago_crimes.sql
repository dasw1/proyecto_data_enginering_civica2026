{{ config( materialized = 'view') }}
with 

source as (

    select * from {{ source('bronze', 'RAW_CHICAGO_CRIMES') }}

),

renamed as (

    select
        id::integer as CRIME_ID,
        TRIM(UPPER(case_number::varchar(10))) as CASE_NUMBER,
        TO_TIMESTAMP(DATE, 'MM/DD/YYYY HH12:MI:SS AM') AS CRIME_DATE,
        TRIM(UPPER(block::VARCHAR(100))) AS "BLOCK",
        TRIM(UPPER(iucr::varchar(6))) AS ILLINOIS_UNIFORM_CRIME_REPORTING,
        TRIM(UPPER(primary_type::VARCHAR(50))) AS PRIMARY_TYPE_CRIME,
        TRIM(UPPER(description::VARCHAR(100))) AS CRIME_DESCRIPTION,
        TRIM(UPPER(COALESCE(location_description::VARCHAR(50),'OTHER (SPECIFY)'))) AS CRIME_LOCATION,
        CASE WHEN UPPER(ARREST) = 'TRUE' THEN TRUE
             WHEN UPPER(ARREST) = 'FALSE' THEN FALSE
             ELSE NULL END                             AS ARREST,
        CASE WHEN UPPER(DOMESTIC) = 'TRUE' THEN TRUE
             WHEN UPPER(DOMESTIC) = 'FALSE' THEN FALSE
             ELSE NULL END                             AS DOMESTIC,
        beat::VARCHAR(4) as DISTRICT_SECTOR_BEAT,
        district::integer as DISTRICT,
        ward::INTEGER AS WARD,
        community_area::INTEGER AS COMMUNITY_AREA,
        TRIM(UPPER(fbi_code::VARCHAR(3))) AS FBI_CODE,
        x_coordinate::INTEGER AS X_CORDINATE,
        y_coordinate::INTEGER AS Y_CORDINATE,
        year::INTEGER AS CRIME_YEAR,
        TO_TIMESTAMP(updated_on, 'MM/DD/YYYY HH12:MI:SS AM') AS LAST_UPDATE,
        latitude::FLOAT AS CRIME_LATITUDE,
        longitude::FLOAT AS CRIME_LONGITUDE,
        TRIM(location::VARCHAR(50)) AS CRIME_LOCATION

    from source

)

select * from renamed