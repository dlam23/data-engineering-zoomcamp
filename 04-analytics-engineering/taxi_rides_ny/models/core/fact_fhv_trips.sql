{{
    config(
        materialized='table'
    )
}}

with fhv_tripdata as (
    select *
    from {{ ref('stg_fhv_tripdata') }}
    --where pickup_locationid is not null and dropoff_locationid is not null
),
dim_zones as (
    select * from {{ ref('dim_zones') }}
    where borough != 'Unknown'
)
select fhv_tripdata.dispatching_base_num,
fhv_tripdata.pickup_locationid,
pickup_zones.borough as pickup_borough,
pickup_zones.zone as pickup_zone,
fhv_tripdata.dropoff_locationid,
dropoff_zones.borough as dropoff_borough,
dropoff_zones.zone as dropoff_zone,
fhv_tripdata.pickup_datetime,
fhv_tripdata.dropoff_datetime,
fhv_tripdata.sr_flag,
fhv_tripdata.affiliated_base_number
from fhv_tripdata
inner join dim_zones as pickup_zones
on fhv_tripdata.pickup_locationid = pickup_zones.locationid
inner join dim_zones as dropoff_zones
on fhv_tripdata.dropoff_locationid = dropoff_zones.locationid


-- dbt build --select <model_name> --vars '{'is_test_run': 'false'}'
{% if var('is_test_run', default=true) %}

  limit 100

{% endif %}