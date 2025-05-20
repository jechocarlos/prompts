-- filepath: /Users/jcarlos/Documents/dev/prompts/utils/use_case_review_db_2.sql
-- Update scripts to replace the form_data_strategic_priorities junction table
-- with an array column in the form_data table

-- This script:
-- 1. Adds strategic_priority_ids array column to form_data
-- 2. Removes the form_data_strategic_priorities junction table
-- 3. Updates all related functions to work with the array column

-- 1. First, add a new column to the form_data table to store an array of strategic priority IDs
ALTER TABLE use_case_review.form_data
ADD COLUMN strategic_priority_ids INTEGER[] DEFAULT '{}';

-- 2. Create a migration function to copy data from junction table to the array column
CREATE OR REPLACE FUNCTION use_case_review.migrate_strategic_priorities_to_arrays()
RETURNS VOID AS $$
DECLARE
    form_record RECORD;
BEGIN
    -- For each form entry with priorities
    FOR form_record IN SELECT DISTINCT form_data_id FROM use_case_review.form_data_strategic_priorities
    LOOP
        -- Update the strategic_priority_ids array
        UPDATE use_case_review.form_data
        SET strategic_priority_ids = (
            SELECT array_agg(strategic_priority_id)
            FROM use_case_review.form_data_strategic_priorities
            WHERE form_data_id = form_record.form_data_id
            GROUP BY form_data_id
        )
        WHERE id = form_record.form_data_id;
    END LOOP;
END;
$$ LANGUAGE plpgsql;

-- 3. Drop the foreign key constraints first
ALTER TABLE IF EXISTS use_case_review.form_data_strategic_priorities
DROP CONSTRAINT IF EXISTS fk_form_data_strategic_priorities_form_data_id;

ALTER TABLE IF EXISTS use_case_review.form_data_strategic_priorities
DROP CONSTRAINT IF EXISTS fk_form_data_strategic_priorities_priority_id;

-- 4. Create a function to directly set strategic priority IDs array
CREATE OR REPLACE FUNCTION use_case_review.set_strategic_priority_ids(
    form_id INTEGER,
    priority_ids INTEGER[]
)
RETURNS VOID AS $$
BEGIN
    -- Update the form_data table directly
    UPDATE use_case_review.form_data
    SET strategic_priority_ids = priority_ids
    WHERE id = form_id;
END;
$$ LANGUAGE plpgsql;

-- 5. Create a function to set strategic priority IDs by names
CREATE OR REPLACE FUNCTION use_case_review.set_strategic_priorities_by_names(
    form_id INTEGER,
    priority_names VARCHAR[]
)
RETURNS VOID AS $$
DECLARE
    priority_ids INTEGER[];
BEGIN
    -- Get the IDs for the priority names
    SELECT array_agg(id) INTO priority_ids
    FROM use_case_review.strategic_priorities
    WHERE name = ANY(priority_names);
    
    -- Set the strategic priority IDs
    PERFORM use_case_review.set_strategic_priority_ids(form_id, priority_ids);
END;
$$ LANGUAGE plpgsql;

-- 6. Create a function to get strategic priority information using the stored array
CREATE OR REPLACE FUNCTION use_case_review.get_strategic_priorities(
    form_id INTEGER
)
RETURNS TABLE(priority_id INTEGER, priority_name VARCHAR, priority_description TEXT) AS $$
BEGIN
    RETURN QUERY
    SELECT sp.id, sp.name, sp.description
    FROM use_case_review.strategic_priorities sp
    JOIN (
        SELECT unnest(strategic_priority_ids) AS id 
        FROM use_case_review.form_data 
        WHERE id = form_id
    ) AS ids ON sp.id = ids.id
    ORDER BY sp.name;
END;
$$ LANGUAGE plpgsql;

-- 7. Create a new view that includes strategic priorities in a JSON format using the array column
CREATE OR REPLACE VIEW use_case_review.form_data_with_priorities AS
SELECT 
    f.*,
    pg.name AS product_group_name,
    cl.name AS complexity_name,
    sv.name AS status_name,
    u.full_name AS assigned_to_name,
    (
        SELECT json_agg(json_build_object(
            'id', sp.id,
            'name', sp.name,
            'description', sp.description
        ))
        FROM use_case_review.strategic_priorities sp
        JOIN unnest(f.strategic_priority_ids) AS sp_id ON sp.id = sp_id
    ) AS strategic_priorities_data
FROM 
    use_case_review.form_data f
LEFT JOIN 
    use_case_review.product_groups pg ON f.product_group_id = pg.id
LEFT JOIN 
    use_case_review.complexity_levels cl ON f.complexity_id = cl.id
LEFT JOIN 
    use_case_review.status_values sv ON f.status_id = sv.id
LEFT JOIN 
    use_case_review.authorized_users u ON f.assigned_to = u.id;

-- 8. Helper function to check if form has a specific strategic priority using the array
CREATE OR REPLACE FUNCTION use_case_review.has_strategic_priority(
    form_id INTEGER,
    priority_name VARCHAR
)
RETURNS BOOLEAN AS $$
DECLARE
    priority_id INTEGER;
    priority_ids INTEGER[];
BEGIN
    -- Get the ID for the priority name
    SELECT id INTO priority_id
    FROM use_case_review.strategic_priorities
    WHERE name = priority_name;
    
    IF NOT FOUND THEN
        RETURN FALSE;
    END IF;
    
    -- Get the strategic priority IDs for the form
    SELECT strategic_priority_ids INTO priority_ids
    FROM use_case_review.form_data
    WHERE id = form_id;
    
    -- Check if the priority ID is in the array
    RETURN priority_id = ANY(priority_ids);
END;
$$ LANGUAGE plpgsql;

-- 9. Drop the junction table after migrating the data
-- First run the migration:
-- SELECT use_case_review.migrate_strategic_priorities_to_arrays();
-- Then execute this drop statement:
DROP TABLE IF EXISTS use_case_review.form_data_strategic_priorities;

-- 10. Sample usage examples (with comments)

-- Example 1: Set strategic priorities by IDs
-- SELECT use_case_review.set_strategic_priority_ids(1, ARRAY[1, 3, 5]);

-- Example 2: Set strategic priorities by names
-- SELECT use_case_review.set_strategic_priorities_by_names(1, ARRAY['Content creation enhancements', 'Marketing']);

-- Example 3: Check if a form has a specific strategic priority
-- SELECT use_case_review.has_strategic_priority(1, 'Marketing');

-- Example 4: Get strategic priorities for a form
-- SELECT * FROM use_case_review.get_strategic_priorities(1);

-- Example 5: Run migration to populate the arrays from the junction table
-- SELECT use_case_review.migrate_strategic_priorities_to_arrays();