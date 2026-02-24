use project;
select * from reviews;

-- Check total records and basic info
SELECT COUNT(*) AS total_records,
       COUNT(DISTINCT id) AS unique_products,
       COUNT(DISTINCT brand) AS unique_brands
FROM reviews;

-- Check date format
SELECT DISTINCT reviews_date 
FROM reviews 
LIMIT 20;

-- Find and remove invalid dates
SELECT reviews_date, COUNT(*) AS count
FROM reviews
WHERE reviews_date IS NOT NULL 
  AND reviews_date = ''
GROUP BY reviews_date;

-- check duplicate records 
SELECT id, COUNT(*) as count
FROM reviews
GROUP BY id
HAVING count > 1;

-- Check for NULL values in critical columns
SELECT 
    COUNT(id) AS id_count,
    COUNT(name) AS name_count,
    COUNT(reviews_rating) AS rating_count,
    COUNT(reviews_text) AS text_count,
    COUNT(reviews_date) AS date_count
FROM reviews;

-- Check rating values
SELECT DISTINCT reviews_rating 
FROM reviews 
ORDER BY reviews_rating;

SET SQL_SAFE_UPDATES = 0;
-- Remove null ratings
DELETE FROM reviews
WHERE reviews_rating NOT BETWEEN 1 AND 5;

-- Find potential duplicates (same product, date, author)
SELECT id, reviews_date, COUNT(*) AS count
FROM reviews
WHERE reviews_date IS NOT NULL
GROUP BY id, reviews_date
HAVING count > 1;

-- Keep only first occurrence of duplicate reviews
DELETE FROM reviews
WHERE id IN (
    SELECT id FROM (
        SELECT id, ROW_NUMBER() OVER (PARTITION BY id, reviews_date ORDER BY id) as rn
        FROM reviews
    ) AS temp
    WHERE rn > 1
);

select * from reviews;
