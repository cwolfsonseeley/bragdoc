select
  entity.pref_class_year,
  count(distinct eval.entity_id) as n_entities
from cdw.d_prospect_evaluation_mv eval
  inner join cdw.d_entity_mv entity on eval.entity_id = entity.entity_id
where
    evaluation_date between 
    to_date(##from##, 'yyyymmdd')
    and to_date(##to##, 'yyyymmdd') 
    and evaluation_type in ('CI', 'CM', 'CC')
group by entity.pref_class_year
order by count(distinct eval.entity_id) desc

