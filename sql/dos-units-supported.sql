select
  assignment.assignment_last_name as development_officer,
  assignment.office_desc as unit,
  count(distinct proposal.proposal_id) as proposals
from 
  cdw.f_proposal_mv proposal 
  left join cdw.f_assignment_mv assignment
  on proposal.proposal_id = assignment.proposal_id
where 
  assignment.assignment_type = 'DO'
  and proposal.user_group in ('PD', 'RS')
  and proposal.date_added between to_date(##from##, 'yyyymmdd') and to_date(##to##, 'yyyymmdd')
  and proposal.proposal_type = 'ORT'
  having count(distinct proposal.proposal_id) > 9
group by assignment.assignment_last_name, assignment.office_desc
