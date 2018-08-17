with rated as (select
  distinct entity.household_entity_id as household_id
from 
    cdw.d_prospect_evaluation_mv eval
    left join cdw.d_entity_mv entity on eval.entity_id = entity.entity_id
where
  evaluation_date between
    to_date(##from##, 'yyyymmdd')
    and to_date(##to##, 'yyyymmdd')
  and evaluation_type in ('CI', 'CM', 'CC')
),

last_contact as (select 
    distinct entity.household_entity_id as household_id,
    max(contact.contact_date) as last_contact
from 
    cdw.d_prospect_evaluation_mv eval
    left join cdw.d_entity_mv entity on eval.entity_id = entity.entity_id
    left join cdw.f_contact_reports_mv contact on eval.entity_id = contact.contact_entity_id
where 
    eval.evaluation_date between 
             to_date(##from##, 'yyyymmdd')
         and to_date(##to##, 'yyyymmdd') 
    and eval.evaluation_type in ('CI', 'CM', 'CC')
    and contact.unit_code != 'SU'
group by entity.household_entity_id
),

proposals as (select 
  distinct entity.household_entity_id as household_id,
  max(proposal.active_ind_cnt) as active_proposal
from 
    cdw.d_prospect_evaluation_mv eval
    left join cdw.d_entity_mv entity on eval.entity_id = entity.entity_id
    left join cdw.f_proposal_mv proposal on eval.entity_id = proposal.entity_id
where 
    eval.evaluation_date between 
             to_date(##from##, 'yyyymmdd')
         and to_date(##to##, 'yyyymmdd') 
    and eval.evaluation_type in ('CI', 'CM', 'CC')
    and proposal.proposal_type = 'ORT'
group by entity.household_entity_id  
),

primary_manager as (select
  distinct entity.household_entity_id as household_id,
  max(assignment_entity_id) as primary_manager
from 
    cdw.d_prospect_evaluation_mv eval
    left join cdw.d_entity_mv entity on eval.entity_id = entity.entity_id
    left join cdw.f_assignment_mv assignment on eval.entity_id = assignment.entity_id
where
    eval.evaluation_date between 
             to_date(##from##, 'yyyymmdd')
         and to_date(##to##, 'yyyymmdd') 
    and eval.evaluation_type in ('CI', 'CM', 'CC')
  and assignment.assignment_type = 'PM'
  and assignment.active_ind = 'Y'
group by entity.household_entity_id
),


counts as (select 
  rated.household_id,
    case
      when last_contact.last_contact between (trunc(add_months(sysdate, -12))) and (sysdate) then 1
      else 0 end as contact_one_year,
    case
      when last_contact.last_contact between (trunc(add_months(sysdate, -60))) and (trunc(add_months(sysdate, -12))) then 1
      else 0 end as contact_five_years,
    case
      when last_contact.last_contact < (trunc(add_months(sysdate, -60))) then 1
      else 0 end as contact_more_than_five_years,
    case
      when proposals.active_proposal > 0 then 1
      else 0 end as active_major_gift_proposal,
    case
      when proposals.active_proposal = 0 then 1
      else 0 end as inactive_major_gift_proposal,
    case
      when primary_manager.primary_manager > 0 then 1
      else 0 end as primary_manager
from
  rated
  left join last_contact on rated.household_id = last_contact.household_id
  left join proposals on rated.household_id = proposals.household_id
  left join primary_manager on rated.household_id = primary_manager.household_id
)

select
  count(distinct counts.household_id) as rated_households,
  sum(counts.contact_one_year) as contacted_within_one_year,
  sum(counts.contact_five_years) as contacted_within_five_years,
  sum(counts.contact_more_than_five_years) as contacted_more_than_five_years,
  sum(counts.active_major_gift_proposal) as active_major_gift_proposal,
  sum(counts.inactive_major_gift_proposal) as inactive_major_gift_proposal,
  sum(counts.primary_manager) as primary_manager
from
  counts

