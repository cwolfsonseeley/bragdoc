with ratings as (select
    extract(YEAR from round(eval.evaluation_date, 'YYYY')) as evaluation_fy,
    count(distinct eval.evaluation_id) as n_ratings,
    count(distinct eval.entity_id) as n_entities_rated,
    count(distinct entity.household_entity_id) as n_households_rated
from
    cdw.d_prospect_evaluation_mv eval
    inner join cdw.d_entity_mv entity on eval.entity_id = entity.entity_id
where
    evaluation_date between
             to_date(##from##, 'yyyymmdd')
         and to_date(##to##, 'yyyymmdd')
    and evaluation_type in ('CI', 'CM', 'CC')
group by
    extract(YEAR from round(evaluation_date, 'YYYY'))
),

capacity_identified as (select
  evaluation_fy,
  sum(identified_capacity) as identified_capacity
from(
select distinct
    entity.household_entity_id,
    extract(YEAR from round(eval.evaluation_date, 'YYYY')) as evaluation_fy,
    first_value(rating_code_type_desc) over (
      partition by entity.household_entity_id
      order by eval.evaluation_date desc, eval.evaluation_id desc
    ) as rating_code_type_desc,
    first_value(
      case rating_code
        when '1'  then 100000000
        when '2'  then  50000000
        when '3'  then  25000000
        when '4'  then  10000000
        when '5'  then   5000000
        when '6'  then   2000000
        when '7'  then   1000000
        when '8'  then    500000
        when '9'  then    250000
        when '10' then    100000
        when '11' then     50000
        when '12' then     25000
        when '13' then     10000
        else 0
      end) over (
        partition by entity.household_entity_id
        order by eval.evaluation_date desc, eval.evaluation_id desc) as identified_capacity
          from
      cdw.d_prospect_evaluation_mv eval
      inner join cdw.d_entity_mv entity on eval.entity_id = entity.entity_id
  where
      evaluation_date
        between to_date(##from##, 'yyyymmdd')
            and to_date(##to##, 'yyyymmdd')
        and evaluation_type in ('CI', 'CM', 'CC')
)
group by
    evaluation_fy)

select
  ratings.evaluation_fy,
  ratings.n_ratings,
  ratings.n_entities_rated,
  ratings.n_households_rated,
  capacity_identified.identified_capacity
from
  ratings
  left join capacity_identified on ratings.evaluation_fy = capacity_identified.evaluation_fy

