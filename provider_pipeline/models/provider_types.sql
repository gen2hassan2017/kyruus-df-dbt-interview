{{ config(materialized='table') }}

with provider_degrees_split as (
    select
        id as provider_id,
        trim(unnest(string_split(degrees, ','))) as degree
    from {{ ref('providers') }}
),

provider_degrees_with_types as (
    select
        pds.provider_id,
        pds.degree,
        dt.ptui,
        dt.rank
    from provider_degrees_split pds
    inner join {{ ref('degree_types') }} dt on pds.degree = dt.degree
),

provider_lowest_rank as (
    select
        provider_id,
        ptui,
        rank() over (partition by provider_id order by rank) as rn
    from provider_degrees_with_types
)

select
    provider_id,
    ptui
from provider_lowest_rank
where rn = 1
order by provider_id