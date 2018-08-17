select 
  extract(YEAR from round(eval.evaluation_date, 'YYYY')) as evaluation_fy,
  entity.household_entity_id, 
  eval.rating_code
from 
  cdw.d_prospect_evaluation_mv eval
  inner join cdw.d_entity_mv entity on eval.entity_id = entity.entity_id
where 
  evaluation_date between 
    to_date(##from##, 'yyyymmdd')
    and to_date(##to##, 'yyyymmdd') 
    and evaluation_type in ('CI', 'CM', 'CC')