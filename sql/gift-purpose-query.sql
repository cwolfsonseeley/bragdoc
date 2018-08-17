select 
    giving.primary_purpose_desc as giving_purpose,
    count(distinct(cads_giving_receipt_nbr)) as gifts
from 
    cdw.d_prospect_evaluation_mv eval
    inner join cdw.f_transaction_detail_mv giving on eval.entity_id = giving.donor_entity_id
where 
    eval.evaluation_date between 
             to_date(##from##, 'yyyymmdd')
         and to_date(##to##, 'yyyymmdd') 
    and eval.evaluation_type in ('CI', 'CM', 'CC')
    and giving.gift_credit_dt between
    to_date(##from##, 'yyyymmdd')
         and to_date(##to##, 'yyyymmdd') 
    and giving.primary_purpose_desc is not null
group by giving.primary_purpose_desc
order by count(distinct(cads_giving_receipt_nbr)) desc
fetch first ##n_purpose## rows only

