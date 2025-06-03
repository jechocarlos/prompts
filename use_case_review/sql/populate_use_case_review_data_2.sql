-- populate_use_case_review_data_2.sql

-- Development Tools Capabilities - Retool
INSERT INTO use_case_review.capabilities (
    name, 
    category_id, 
    tags, 
    description, 
    implementation_examples, 
    required_resources, 
    limitations, 
    is_active, 
    maturity_level_id,
    created_by,
    updated_by
)
VALUES
    (
        'Retool', 
        (SELECT id FROM use_case_review.capability_categories WHERE name = 'Development Tools'), 
        ARRAY['internal tools', 'app builder', 'low-code development', 'business applications', 'admin panels', 'dashboards', 'database UI'],
        'Platform for quickly building internal tools, admin panels, dashboards and CRUD apps with a drag-and-drop interface while allowing custom code when needed',
        ARRAY['Customer management portals', 'Data administration interfaces', 'Business operations dashboards', 'Resource approval workflows'],
        'Retool account, Database/API connections, Basic SQL knowledge, JavaScript for advanced customization',
        'Free plan has limitations on users and features. Requires knowledge of data sources to connect. More complex applications may still need custom code components.',
        TRUE,
        (SELECT id FROM use_case_review.maturity_levels WHERE name = 'Production-Ready'),
        (SELECT id FROM use_case_review.authorized_users WHERE email = 'jericho.carlos@cambridge.org'),
        (SELECT id FROM use_case_review.authorized_users WHERE email = 'jericho.carlos@cambridge.org')
    );

