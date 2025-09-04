{{ config(materialized='table') }}

with provider_address_details as (
    select
        p.id as provider_id,
        a.id as address_id,
        a.street,
        a.rank
    from {{ ref('providers') }} p
    left join {{ ref('provider_addresses') }} pa on p.id = pa.provider_id
    left join {{ ref('addresses') }} a on pa.address_id = a.id
),

provider_addresses_aggregated as (
    select
        provider_id,
        case
            when count(address_id) > 0 then
                array_agg(
                    {'id': address_id, 'street': street, 'rank': rank}
                )
            else cast([] as struct(id integer, street varchar, rank integer)[])
        end as addresses
    from provider_address_details
    group by provider_id
)

select
    provider_id,
    addresses
from provider_addresses_aggregated
order by provider_id