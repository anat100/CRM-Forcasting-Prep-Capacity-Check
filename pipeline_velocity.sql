-- Pipeline velocity per AE and for the whole team (PostgreSQL).
--
-- Pipeline velocity = open deals x win rate x average won deal size / sales cycle length (days)
-- It estimates how much revenue the pipeline produces per day.
-- Run it in DBeaver or psql. It does not change any data.
--
-- Reading the result:
--   win_rate_pct     won / (won + lost), open deals excluded
--   avg_won_size     average amount of Closed Won deals (EUR)
--   avg_cycle_days   average days from created_at to closed_at on won deals
--   velocity_per_day EUR per day
--   velocity_30d     the same figure for 30 days, easier to read
-- Be careful with AEs who have very few closed deals: their numbers are a small sample.

with by_owner as (
  select
    coalesce(nullif(owner, ''), '(no owner)')                                  as owner,
    count(*) filter (where closed_at is null)                                  as open_deals,
    count(*) filter (where stage = 'Closed Won')                               as won_deals,
    count(*) filter (where stage = 'Closed Lost')                              as lost_deals,
    avg(amount) filter (where stage = 'Closed Won')                            as avg_won_size,
    avg(closed_at::date - created_at::date) filter (where stage = 'Closed Won') as avg_cycle_days
  from deals
  group by 1
),
team as (
  select
    'TEAM'                                                                     as owner,
    count(*) filter (where closed_at is null)                                  as open_deals,
    count(*) filter (where stage = 'Closed Won')                               as won_deals,
    count(*) filter (where stage = 'Closed Lost')                              as lost_deals,
    avg(amount) filter (where stage = 'Closed Won')                            as avg_won_size,
    avg(closed_at::date - created_at::date) filter (where stage = 'Closed Won') as avg_cycle_days
  from deals
),
all_rows as (
  select * from by_owner where owner <> '(no owner)'
  union all
  select * from team
)
select
  owner,
  open_deals,
  won_deals,
  lost_deals,
  round(100.0 * won_deals / nullif(won_deals + lost_deals, 0), 1)              as win_rate_pct,
  round(avg_won_size)                                                          as avg_won_size,
  round(avg_cycle_days)                                                        as avg_cycle_days,
  round(open_deals * (won_deals::numeric / nullif(won_deals + lost_deals, 0))
        * avg_won_size / nullif(avg_cycle_days, 0))                            as velocity_per_day,
  round(30 * open_deals * (won_deals::numeric / nullif(won_deals + lost_deals, 0))
        * avg_won_size / nullif(avg_cycle_days, 0))                            as velocity_30d
from all_rows
order by (owner = 'TEAM'), velocity_per_day desc nulls last;
