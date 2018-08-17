select
  extract(YEAR from round(eval.evaluation_date, 'YYYY')) as evaluation_fy,
  eval.rating_code,
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
  rating_code,
  extract(YEAR from round(evaluation_date, 'YYYY'))

