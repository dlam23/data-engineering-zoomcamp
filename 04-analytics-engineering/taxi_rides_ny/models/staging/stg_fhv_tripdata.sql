{{
    config(
        materialized='view'
    )
}}

with tripdata as 
(
  select *,
  from {{ source('staging','external_fhv_tripdata') }}
  where extract(year from cast(pickup_datetime as timestamp)) = 2019
)
select
    -- identifiers
    dispatching_base_num,
    Affiliated_base_number as affiliated_base_number,
    cast(SR_Flag as numeric) as sr_flag,
    {{ dbt.safe_cast("PUlocationID", api.Column.translate_type("integer")) }} as pickup_locationid,
    {{ dbt.safe_cast("DOlocationID", api.Column.translate_type("integer")) }} as dropoff_locationid,
    
    -- timestamps
    cast(pickup_datetime as timestamp) as pickup_datetime,
    cast(dropOff_datetime as timestamp) as dropoff_datetime

from tripdata
--where extract(year from pickup_datetime) = 2019

-- dbt build --select <model_name> --vars '{'is_test_run': 'false'}'
{% if var('is_test_run', default=true) %}

  limit 100

{% endif %}