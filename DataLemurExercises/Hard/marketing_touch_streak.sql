WITH numbered_week AS
(
  SELECT
      contact_id AS contact_id,
      event_type AS event_type,
      CASE
          WHEN
               LAG(EXTRACT(WEEK FROM event_date)) 
               OVER(PARTITION BY contact_id ORDER BY event_date) IS NULL
               THEN EXTRACT(WEEK FROM event_date) - 1
          ELSE
               LAG(EXTRACT(WEEK FROM event_date)) 
               OVER(PARTITION BY contact_id ORDER BY event_date)
      END AS previous_week,
      EXTRACT(WEEK FROM event_date) AS current_week,
      CASE
          WHEN
              LEAD(EXTRACT(WEEK FROM event_date)) 
              OVER(PARTITION BY contact_id ORDER BY event_date) IS NULL
              THEN EXTRACT(WEEK FROM event_date) + 1
          ELSE
              LEAD(EXTRACT(WEEK FROM event_date)) 
              OVER(PARTITION BY contact_id ORDER BY event_date)
      END AS next_week,
      ROW_NUMBER() OVER(PARTITION BY contact_id) AS ranking
  FROM
      marketing_touches
),
ranked_cte AS
(
  SELECT 
        nw1.contact_id AS contact_id,
        event_type AS event_type,
        ranking AS ranking
  FROM
        numbered_week nw1
  INNER JOIN
        crm_contacts crm
  ON
        nw1.contact_id = crm.contact_id
  WHERE
        (ranking = 2 
        AND (next_week - current_week = 1 AND current_week - previous_week = 1))
),
event_cte AS
(
SELECT 
      nw1.contact_id AS contact_id,
      event_type AS event_type,
      ranking AS ranking
FROM
      numbered_week nw1
INNER JOIN
      crm_contacts crm
ON
      nw1.contact_id = crm.contact_id
WHERE
      event_type = 'trial_request'
)
SELECT
      crm.email
FROM
    crm_contacts crm 
INNER JOIN
    ranked_cte rcte
ON
    crm.contact_id = rcte.contact_id
INNER JOIN
    event_cte ecte
ON
    rcte.contact_id = ecte.contact_id