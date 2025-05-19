-- filepath: /Users/jcarlos/Documents/dev/prompts/utils/use_case_review_db.sql
-- SQL Script to create tables for AI Change Request System
-- Schema: use_case_review

-- Create schema if it doesn't exist
CREATE SCHEMA IF NOT EXISTS use_case_review;

-- Table for status values - Reference table
CREATE TABLE use_case_review.status_values (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL UNIQUE,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table for product groups - Reference table
CREATE TABLE use_case_review.product_groups (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table for implementation complexity levels - Reference table
CREATE TABLE use_case_review.complexity_levels (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL UNIQUE,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table for strategic priorities - Reference table
CREATE TABLE use_case_review.strategic_priorities (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Junction table for form data and strategic priorities (many-to-many)
CREATE TABLE use_case_review.form_data_strategic_priorities (
    form_data_id INTEGER NOT NULL,
    strategic_priority_id INTEGER NOT NULL,
    PRIMARY KEY (form_data_id, strategic_priority_id)
);

-- Table for maturity levels - Reference table
CREATE TABLE use_case_review.maturity_levels (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table for capability categories - Reference table
CREATE TABLE use_case_review.capability_categories (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table 1: form_data_table - Stores all interview responses and insights
CREATE TABLE use_case_review.form_data (
    id SERIAL PRIMARY KEY,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    -- Initiative Overview
    initiative_name VARCHAR(200) NOT NULL,
    internal_priority BOOLEAN,
    description TEXT,
    product_group_id INTEGER NOT NULL, -- Reference to product_groups table
    product_contacts TEXT[], -- Array of email addresses
    sponsor_name VARCHAR(200),
    -- Strategic priorities now handled through junction table
    
    -- Problem Statement
    business_situation TEXT,
    end_users TEXT,
    user_count INTEGER CHECK (user_count IS NULL OR user_count >= 0),
    benefits TEXT,
    success_metrics TEXT,
    data_needs TEXT,
    
    -- Capability Assessment
    matched_capabilities INTEGER[], -- References to capabilities_table ids
    capability_gaps TEXT,
    complexity_id INTEGER NOT NULL, -- Reference to complexity_levels table
    
    -- Conclusion and Next Steps
    assessment_summary TEXT,
    next_steps TEXT,
    additional_info_needed TEXT,
    
    -- Status tracking
    status_id INTEGER NOT NULL, -- Reference to status_values table
    
    -- Additional metadata
    follow_up_flags TEXT[] -- Array of fields needing follow-up
);

-- Table 2: capabilities_table - Stores all Gen AI CoE capabilities 
CREATE TABLE use_case_review.capabilities (
    id SERIAL PRIMARY KEY,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_by INTEGER, -- Reference to authorized_users_table
    updated_by INTEGER, -- Reference to authorized_users_table
    
    -- Capability details
    name VARCHAR(200) NOT NULL,
    category_id INTEGER NOT NULL, -- Reference to capability_categories table
    tags TEXT[], -- Array of relevant tags (chat completion, RAG, agents, etc.)
    description TEXT,
    
    -- Usage information
    implementation_examples TEXT[], -- References to previous implementations
    required_resources TEXT,
    limitations TEXT,
    
    -- Status
    is_active BOOLEAN DEFAULT TRUE,
    maturity_level_id INTEGER NOT NULL -- Reference to maturity_levels table
);

-- Create indexes for faster searching
CREATE INDEX idx_capabilities_tags ON use_case_review.capabilities USING GIN (tags);
CREATE INDEX idx_form_data_initiative_name ON use_case_review.form_data(initiative_name);
CREATE INDEX idx_form_data_status_id ON use_case_review.form_data(status_id);
CREATE INDEX idx_form_data_assigned_to ON use_case_review.form_data(assigned_to);

-- Table 3: authorized_users_table - Stores users who can update capabilities
CREATE TABLE use_case_review.authorized_users (
    id SERIAL PRIMARY KEY,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    -- User information (manually entered)
    email VARCHAR(255) NOT NULL UNIQUE,       -- User email
    full_name VARCHAR(200) NOT NULL,          -- User's full name
);

-- Create index for authorized_users email
CREATE INDEX idx_authorized_users_email ON use_case_review.authorized_users(email);

-- Create index for capabilities by category
CREATE INDEX idx_capabilities_category ON use_case_review.capabilities(category_id);

-- Add foreign key constraints
ALTER TABLE use_case_review.form_data 
    ADD CONSTRAINT fk_form_data_assigned_to 
    FOREIGN KEY (assigned_to) 
    REFERENCES use_case_review.authorized_users(id)
    ON DELETE SET NULL
    ON UPDATE CASCADE;

ALTER TABLE use_case_review.form_data 
    ADD CONSTRAINT fk_form_data_status_id 
    FOREIGN KEY (status_id) 
    REFERENCES use_case_review.status_values(id)
    ON DELETE RESTRICT
    ON UPDATE CASCADE;
    
ALTER TABLE use_case_review.form_data 
    ADD CONSTRAINT fk_form_data_product_group_id 
    FOREIGN KEY (product_group_id) 
    REFERENCES use_case_review.product_groups(id)
    ON DELETE RESTRICT
    ON UPDATE CASCADE;
    
ALTER TABLE use_case_review.form_data 
    ADD CONSTRAINT fk_form_data_complexity_id 
    FOREIGN KEY (complexity_id) 
    REFERENCES use_case_review.complexity_levels(id)
    ON DELETE RESTRICT
    ON UPDATE CASCADE;
    
ALTER TABLE use_case_review.form_data_strategic_priorities 
    ADD CONSTRAINT fk_form_data_strategic_priorities_form_data_id 
    FOREIGN KEY (form_data_id) 
    REFERENCES use_case_review.form_data(id)
    ON DELETE CASCADE;
    
ALTER TABLE use_case_review.form_data_strategic_priorities 
    ADD CONSTRAINT fk_form_data_strategic_priorities_priority_id 
    FOREIGN KEY (strategic_priority_id) 
    REFERENCES use_case_review.strategic_priorities(id)
    ON DELETE RESTRICT
    ON UPDATE CASCADE;

ALTER TABLE use_case_review.capabilities 
    ADD CONSTRAINT fk_capabilities_created_by 
    FOREIGN KEY (created_by) 
    REFERENCES use_case_review.authorized_users(id)
    ON DELETE SET NULL
    ON UPDATE CASCADE;

ALTER TABLE use_case_review.capabilities 
    ADD CONSTRAINT fk_capabilities_updated_by 
    FOREIGN KEY (updated_by) 
    REFERENCES use_case_review.authorized_users(id)
    ON DELETE SET NULL
    ON UPDATE CASCADE;
    
ALTER TABLE use_case_review.capabilities 
    ADD CONSTRAINT fk_capabilities_category_id 
    FOREIGN KEY (category_id) 
    REFERENCES use_case_review.capability_categories(id)
    ON DELETE RESTRICT
    ON UPDATE CASCADE;
    
ALTER TABLE use_case_review.capabilities 
    ADD CONSTRAINT fk_capabilities_maturity_level_id 
    FOREIGN KEY (maturity_level_id) 
    REFERENCES use_case_review.maturity_levels(id)
    ON DELETE RESTRICT
    ON UPDATE CASCADE;

    
-- Insert sample maturity levels
INSERT INTO use_case_review.maturity_levels (name, description)
VALUES
    ('Prototype', 'Early development stage with basic functionality, not yet ready for production use'),
    ('Beta', 'Feature complete but still undergoing testing and may have bugs'),
    ('Production-Ready', 'Fully tested and stable, suitable for production use'),
    ('Mature', 'Well-established with extensive usage history and proven reliability'),
    ('Legacy', 'Still supported but being phased out in favor of newer solutions');

-- Insert sample status values
INSERT INTO use_case_review.status_values (name, description)
VALUES
    ('Submitted', 'Initial submission, awaiting review'),
    ('In Review', 'Currently being reviewed by the AI CoE team'),
    ('Needs Information', 'Additional information required from stakeholders'),
    ('Approved', 'Use case has been approved for implementation'),
    ('In Development', 'Currently being implemented'),
    ('In Testing', 'Solution is being tested with stakeholders'),
    ('Completed', 'Use case has been successfully implemented'),
    ('Rejected', 'Use case has been declined'),
    ('On Hold', 'Implementation paused temporarily');
    
-- Insert sample product groups
INSERT INTO use_case_review.product_groups (name, description)
VALUES
    ('English', 'English language teaching products and services'),
    ('Education', 'Educational materials and platforms'),
    ('Academic', 'Academic research and publishing services'),
    ('The Partnership', 'Partnership programs and collaborative initiatives'),
    ('Operations', 'Operational systems and processes'),
    ('Shared Service', 'Shared services including HR, Finance etc.');
    
-- Insert sample complexity levels
INSERT INTO use_case_review.complexity_levels (name, description)
VALUES
    ('Low', 'Simple implementation with minimal integration requirements'),
    ('Medium', 'Moderate complexity requiring some integration and testing'),
    ('High', 'Complex implementation with significant technical challenges');
    
-- Insert sample strategic priorities
INSERT INTO use_case_review.strategic_priorities (name, description)
VALUES
    ('Content creation enhancements', 'Improving content creation processes and quality'),
    ('Customer services efficiencies and improvements', 'Enhancing customer service through AI'),
    ('Marketing', 'AI applications for marketing and promotional activities'),
    ('Software development productivity gains', 'Using AI to improve software development efficiency'),
    ('Image generation', 'Creating visual content through AI technology');

-- Create a view for form data with all reference values
CREATE VIEW use_case_review.form_data_view AS
SELECT 
    f.id,
    f.initiative_name,
    f.internal_priority,
    f.description,
    pg.name as product_group,
    f.sponsor_name,
    f.business_situation,
    f.end_users,
    f.user_count,
    f.benefits,
    f.success_metrics,
    cl.name as complexity_level,
    sv.name as status,
    u.full_name as assigned_to_name,
    f.created_at,
    f.updated_at
FROM 
    use_case_review.form_data f
JOIN 
    use_case_review.product_groups pg ON f.product_group_id = pg.id
JOIN 
    use_case_review.complexity_levels cl ON f.complexity_id = cl.id
JOIN 
    use_case_review.status_values sv ON f.status_id = sv.id
LEFT JOIN 
    use_case_review.authorized_users u ON f.assigned_to = u.id;

-- Create a view for form data strategic priorities
CREATE VIEW use_case_review.form_data_priorities_view AS
SELECT 
    f.id as form_id,
    f.initiative_name,
    sp.name as strategic_priority
FROM 
    use_case_review.form_data f
JOIN 
    use_case_review.form_data_strategic_priorities fdsp ON f.id = fdsp.form_data_id
JOIN 
    use_case_review.strategic_priorities sp ON fdsp.strategic_priority_id = sp.id;

-- Create triggers to automatically update the updated_at timestamp
CREATE OR REPLACE FUNCTION use_case_review.update_modified_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ LANGUAGE 'plpgsql';

-- Add triggers to all tables with updated_at column
CREATE TRIGGER update_form_data_modtime
    BEFORE UPDATE ON use_case_review.form_data
    FOR EACH ROW EXECUTE FUNCTION use_case_review.update_modified_column();

CREATE TRIGGER update_capabilities_modtime
    BEFORE UPDATE ON use_case_review.capabilities
    FOR EACH ROW EXECUTE FUNCTION use_case_review.update_modified_column();

CREATE TRIGGER update_authorized_users_modtime
    BEFORE UPDATE ON use_case_review.authorized_users
    FOR EACH ROW EXECUTE FUNCTION use_case_review.update_modified_column();

-- Create a view for easier capability searching
CREATE VIEW use_case_review.capability_view AS
SELECT 
    c.id,
    c.name,
    cat.name as category,
    c.tags,
    c.description,
    c.required_resources,
    c.limitations,
    ml.name as maturity_level,
    creator.full_name as created_by_name,
    creator.email as created_by_email,
    updater.full_name as updated_by_name,
    updater.email as updated_by_email,
    c.created_at,
    c.updated_at
FROM 
    use_case_review.capabilities c
LEFT JOIN 
    use_case_review.authorized_users creator ON c.created_by = creator.id
LEFT JOIN 
    use_case_review.authorized_users updater ON c.updated_by = updater.id
JOIN 
    use_case_review.capability_categories cat ON c.category_id = cat.id
JOIN 
    use_case_review.maturity_levels ml ON c.maturity_level_id = ml.id
WHERE 
    c.is_active = TRUE;