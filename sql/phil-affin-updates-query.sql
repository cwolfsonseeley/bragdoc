select 
    extract(YEAR from round(date_added, 'YYYY')) as fiscal_year,
    count(distinct entity_id || '-' || xsequence) as philanthropic_affinities_added
from cdw.d_oth_phil_affinity_mv
where 
    date_added between 
        to_date(##from##, 'yyyymmdd')
        and to_date(##to##, 'yyyymmdd')
    and user_group = 'RS'
group by extract(YEAR from round(date_added, 'YYYY'))
