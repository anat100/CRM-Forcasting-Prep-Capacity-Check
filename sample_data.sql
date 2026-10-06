-- Synthetic sample data for the CRM Hygiene Agent. No real people or companies.
-- Dates are relative to today (current_date), so the data never goes stale.
-- Run sql/schema.sql first.
--
-- The data is built to show three things:
--
-- 1. Hygiene problems for every check to find:
--    a duplicate contact (Felix Brandl), a contact with no company who was never touched,
--    one with no lead source, one with an invalid email, a contact and a deal with no owner,
--    two stale deals (both Marcus), a deal open for 6+ months, a deal with no amount,
--    and a deal linked to a contact that does not exist.
--
-- 2. Pipeline velocity differences between AEs:
--    Lena closes fast and wins most deals (cycles of about 33 days, win rate 75%).
--    Marcus has long cycles and a lower win rate (about 112 days, win rate 40%).
--    Sofia is new, with only one closed deal, so her numbers are a small sample.
--
-- 3. Uneven territories:
--    Marcus holds the most accounts and pipeline, Sofia the least.

insert into contacts (hubspot_id, first_name, last_name, email, email_domain, company, lead_source, owner, last_activity) values
  ('k001', 'Felix', 'Brandl', 'felix.brandl@tannenberg.example', 'tannenberg.example', 'Tannenberg Robotics', 'Webinar', 'Lena Hoffmann', (current_date - 3)::timestamp),
  ('k002', 'Felix', 'Brandl', 'f.brandl@tannenberg.example', 'tannenberg.example', 'Tannenberg Robotics', 'Webinar', 'Lena Hoffmann', (current_date - 18)::timestamp),
  ('k003', 'Greta', 'Lindqvist', 'greta@veridianbio.example', 'veridianbio.example', 'Veridian Bio', 'Referral', 'Lena Hoffmann', (current_date - 5)::timestamp),
  ('k004', 'Hannes', 'Moser', 'hannes@quartzins.example', 'quartzins.example', 'Quartz Insurance', 'Outbound', 'Lena Hoffmann', (current_date - 7)::timestamp),
  ('k005', 'Isabel', 'Frey', 'isabel@meridiantravel.example', 'meridiantravel.example', 'Meridian Travel', 'Event', 'Lena Hoffmann', (current_date - 10)::timestamp),
  ('k006', 'Jakob', 'Winter', 'jakob@solace.example', 'solace.example', 'Solace Energy', 'Referral', 'Lena Hoffmann', (current_date - 2)::timestamp),
  ('k007', 'Katrin', 'Ebner', 'katrin@ostwind.example', 'ostwind.example', 'Ostwind Media', 'Webinar', 'Lena Hoffmann', (current_date - 9)::timestamp),
  ('k008', 'Leon', 'Pohl', 'leon@ravennatextiles.example', 'ravennatextiles.example', 'Ravenna Textiles', 'Outbound', 'Marcus Bauer', (current_date - 35)::timestamp),
  ('k009', 'Mara', 'Ziegler', 'mara@pinecrest.example', 'pinecrest.example', 'Pinecrest Logistics', 'Event', 'Marcus Bauer', (current_date - 48)::timestamp),
  ('k010', 'Nils', 'Haas', 'nils@silverline.example', 'silverline.example', 'Silverline Bank', 'Referral', 'Marcus Bauer', (current_date - 22)::timestamp),
  ('k011', 'Olivia', 'Dorn', 'olivia@harborco.example', 'harborco.example', 'Harbor & Co', null, 'Marcus Bauer', (current_date - 40)::timestamp),
  ('k012', 'Pascal', 'Engel', 'pascal.engel', null, 'Northgate Pharma', 'Outbound', 'Marcus Bauer', (current_date - 55)::timestamp),
  ('k013', 'Rhea', 'Sommer', 'rhea@zephyr.example', 'zephyr.example', 'Zephyr Aviation', 'Event', 'Marcus Bauer', (current_date - 65)::timestamp),
  ('k014', 'Stefan', 'Vogt', 'stefan@luminaretail.example', 'luminaretail.example', 'Lumina Retail', 'Webinar', 'Marcus Bauer', (current_date - 28)::timestamp),
  ('k015', 'Tessa', 'Albrecht', 'tessa@cobaltmining.example', 'cobaltmining.example', null, 'Outbound', 'Marcus Bauer', null),
  ('k016', 'Uwe', 'Kraft', 'uwe@kiteanalytics.example', 'kiteanalytics.example', 'Kite Analytics', 'Inbound', 'Sofia Keller', (current_date - 4)::timestamp),
  ('k017', 'Vera', 'Lang', 'vera@juniperfoods.example', 'juniperfoods.example', 'Juniper Foods', 'Referral', 'Sofia Keller', (current_date - 6)::timestamp),
  ('k018', 'Wim', 'Decker', 'wim@driftsystems.example', 'driftsystems.example', 'Drift Systems', 'Inbound', null, (current_date - 14)::timestamp);

insert into deals (hubspot_id, name, stage, owner, amount, contact_id, created_at, last_activity, closed_at) values
  ('e001', 'Tannenberg robotics fleet', 'Closed Won', 'Lena Hoffmann', 62000, 'k001', (current_date - 80)::timestamp, (current_date - 45)::timestamp, (current_date - 45)::timestamp),
  ('e002', 'Veridian lab suite', 'Closed Won', 'Lena Hoffmann', 48000, 'k003', (current_date - 95)::timestamp, (current_date - 62)::timestamp, (current_date - 62)::timestamp),
  ('e003', 'Quartz policy platform', 'Closed Won', 'Lena Hoffmann', 55000, 'k004', (current_date - 70)::timestamp, (current_date - 38)::timestamp, (current_date - 38)::timestamp),
  ('e004', 'Meridian booking tool', 'Closed Lost', 'Lena Hoffmann', 30000, 'k005', (current_date - 85)::timestamp, (current_date - 50)::timestamp, (current_date - 50)::timestamp),
  ('e005', 'Solace grid analytics', 'Proposal Sent', 'Lena Hoffmann', 90000, 'k006', (current_date - 40)::timestamp, (current_date - 2)::timestamp, null),
  ('e006', 'Ostwind ad platform', 'Demo Done', 'Lena Hoffmann', 45000, 'k007', (current_date - 28)::timestamp, (current_date - 6)::timestamp, null),
  ('e007', 'Meridian upgrade', 'Demo Booked', 'Lena Hoffmann', 25000, 'k005', (current_date - 14)::timestamp, (current_date - 5)::timestamp, null),
  ('e008', 'Tannenberg expansion', 'New', 'Lena Hoffmann', 35000, 'k001', (current_date - 6)::timestamp, (current_date - 3)::timestamp, null),
  ('e009', 'Ravenna weave line', 'Closed Won', 'Marcus Bauer', 70000, 'k008', (current_date - 190)::timestamp, (current_date - 70)::timestamp, (current_date - 70)::timestamp),
  ('e010', 'Silverline core upgrade', 'Closed Won', 'Marcus Bauer', 95000, 'k010', (current_date - 160)::timestamp, (current_date - 55)::timestamp, (current_date - 55)::timestamp),
  ('e011', 'Pinecrest routing', 'Closed Lost', 'Marcus Bauer', 40000, 'k009', (current_date - 170)::timestamp, (current_date - 100)::timestamp, (current_date - 100)::timestamp),
  ('e012', 'Harbor audit', 'Closed Lost', 'Marcus Bauer', 28000, 'k011', (current_date - 150)::timestamp, (current_date - 90)::timestamp, (current_date - 90)::timestamp),
  ('e013', 'Northgate trial', 'Closed Lost', 'Marcus Bauer', 52000, 'k012', (current_date - 140)::timestamp, (current_date - 75)::timestamp, (current_date - 75)::timestamp),
  ('e014', 'Zephyr fleet analytics', 'Proposal Sent', 'Marcus Bauer', 120000, 'k013', (current_date - 100)::timestamp, (current_date - 41)::timestamp, null),
  ('e015', 'Lumina omni-channel', 'Demo Done', 'Marcus Bauer', 60000, 'k014', (current_date - 55)::timestamp, (current_date - 12)::timestamp, null),
  ('e016', 'Ravenna phase 2', 'New', 'Marcus Bauer', 30000, 'k008', (current_date - 9)::timestamp, (current_date - 9)::timestamp, null),
  ('e017', 'Silverline treasury', 'Demo Booked', 'Marcus Bauer', 80000, 'k010', (current_date - 200)::timestamp, (current_date - 15)::timestamp, null),
  ('e018', 'Pinecrest renewal', 'Proposal Sent', 'Marcus Bauer', 45000, 'k009', (current_date - 75)::timestamp, (current_date - 33)::timestamp, null),
  ('e019', 'Kite dashboards', 'Closed Won', 'Sofia Keller', 20000, 'k016', (current_date - 50)::timestamp, (current_date - 20)::timestamp, (current_date - 20)::timestamp),
  ('e020', 'Juniper supply analytics', 'Demo Booked', 'Sofia Keller', 38000, 'k017', (current_date - 22)::timestamp, (current_date - 4)::timestamp, null),
  ('e021', 'Kite upsell', 'New', 'Sofia Keller', null, 'k016', (current_date - 7)::timestamp, (current_date - 7)::timestamp, null),
  ('e023', 'Phantom Corp deal', 'Demo Booked', 'Sofia Keller', 33000, 'k999', (current_date - 30)::timestamp, (current_date - 21)::timestamp, null),
  ('e022', 'Drift Systems pilot', 'Demo Booked', null, 26000, 'k018', (current_date - 18)::timestamp, (current_date - 18)::timestamp, null);
