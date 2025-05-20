-- SQL Script to populate the capability categories, capabilities, and authorized users tables
-- for the AI Change Request System
-- Schema: use_case_review

-- First, clean up any existing sample data that might cause conflicts
-- Note: This is commented out for safety. Uncomment if you want to clear existing data
-- DELETE FROM use_case_review.capabilities;
-- DELETE FROM use_case_review.capability_categories;

-- Insert sample capability categories, checking for existing categories first
INSERT INTO use_case_review.capability_categories (name, description)
SELECT t.name, t.description
FROM (VALUES 
    ('Natural Language Processing', 'Capabilities related to understanding and generating human language'),
    ('Computer Vision', 'Capabilities related to image and video analysis and generation'),
    ('Data Analysis', 'Capabilities related to structured data processing and insights'),
    ('Agent Systems', 'Capabilities related to autonomous AI agents'),
    ('Knowledge Management', 'Capabilities related to information retrieval and organization'),
    ('Multimodal', 'Capabilities that combine multiple types of inputs or outputs'),
    ('Infrastructure', 'Capabilities related to deployment and infrastructure management'),
    ('Model Platforms', 'Capabilities related to AI model providers and platforms'),
    ('Development Tools', 'Capabilities related to software development and integration'),
    ('Evaluation', 'Capabilities related to testing, evaluation, and quality assurance')
) AS t(name, description)
WHERE NOT EXISTS (
    SELECT 1 FROM use_case_review.capability_categories 
    WHERE name = t.name
);

-- Next, insert sample authorized users (checking if they exist first)
INSERT INTO use_case_review.authorized_users (email, full_name, user_role)
SELECT 'jericho.carlos@cambridge.org', 'Jecho Carlos', 'admin'
WHERE NOT EXISTS (
    SELECT 1 FROM use_case_review.authorized_users 
    WHERE email = 'jericho.carlos@cambridge.org'
);

-- Below we'll add capabilities for each category
-- Each capability will reference the category, maturity level, and your user account

-- Model Platform Capabilities
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
        'Azure OpenAI Models', 
        (SELECT id FROM use_case_review.capability_categories WHERE name = 'Model Platforms'), 
        ARRAY['AI assistants', 'text generation', 'content creation', 'Microsoft-powered AI', 'enterprise AI'],
        'Microsoft-hosted AI technology that powers intelligent text creation, analysis, and conversation with enterprise-level security and reliability',
        ARRAY['Customer service virtual assistants', 'Automated content writing tools', 'Document analysis solutions'],
        'Microsoft Azure subscription, Access credentials, Usage monitoring, AI training expertise',
        'Higher cost compared to open-source alternatives. Subject to Azure-specific usage policies and restrictions.',
        TRUE,
        (SELECT id FROM use_case_review.maturity_levels WHERE name = 'Mature'),
        (SELECT id FROM use_case_review.authorized_users WHERE email = 'jericho.carlos@cambridge.org'),
        (SELECT id FROM use_case_review.authorized_users WHERE email = 'jericho.carlos@cambridge.org')
    ),
    (
        'AWS Bedrock Models', 
        (SELECT id FROM use_case_review.capability_categories WHERE name = 'Model Platforms'), 
        ARRAY['AI marketplace', 'text and image generation', 'multiple AI providers', 'Amazon AI', 'business AI'],
        'Amazon-hosted platform offering access to various AI technologies from different providers in one place, with business-grade security',
        ARRAY['Multilingual customer communication tools', 'Decision-making assistants', 'Industry-specific virtual experts'],
        'Amazon Web Services account, Access permissions, Integration with existing systems',
        'Variable performance across different model providers. Cost management needs careful attention.',
        TRUE,
        (SELECT id FROM use_case_review.maturity_levels WHERE name = 'Production-Ready'),
        (SELECT id FROM use_case_review.authorized_users WHERE email = 'jericho.carlos@cambridge.org'),
        (SELECT id FROM use_case_review.authorized_users WHERE email = 'jericho.carlos@cambridge.org')
    );

-- Knowledge Management Capabilities
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
        'Qdrant Vector Store', 
        (SELECT id FROM use_case_review.capability_categories WHERE name = 'Knowledge Management'), 
        ARRAY['smart information storage', 'meaning-based search', 'content understanding', 'intelligent retrieval', 'knowledge organization'],
        'Advanced information storage system that understands the meaning of content, enabling intelligent searching beyond keywords',
        ARRAY['Smart company knowledge base', 'Intelligent product recommendation tools', 'Content discovery systems'],
        'Information repository, Content processing system, Search enhancement technology',
        'Requires quality content to deliver good results. Performance depends on how well information is organized and indexed.',
        TRUE,
        (SELECT id FROM use_case_review.maturity_levels WHERE name = 'Prototype'),
        (SELECT id FROM use_case_review.authorized_users WHERE email = 'jericho.carlos@cambridge.org'),
        (SELECT id FROM use_case_review.authorized_users WHERE email = 'jericho.carlos@cambridge.org')
    ),
    (
        'Neo4j Knowledge Graph', 
        (SELECT id FROM use_case_review.capability_categories WHERE name = 'Knowledge Management'), 
        ARRAY['relationship mapping', 'connection visualization', 'network insights', 'pattern discovery'],
        'System for mapping and visualizing connections between information, people, and concepts to uncover hidden insights and patterns',
        ARRAY['Research connection explorer', 'Organization structure visualization', 'Product relationship mapping'],
        'Information about relationships, Pattern mapping tool, Connection visualization system',
        'Complexity increases with the number of connections. Requires clear definitions of how items relate to each other.',
        TRUE,
        (SELECT id FROM use_case_review.maturity_levels WHERE name = 'Prototype'),
        (SELECT id FROM use_case_review.authorized_users WHERE email = 'jericho.carlos@cambridge.org'),
        (SELECT id FROM use_case_review.authorized_users WHERE email = 'jericho.carlos@cambridge.org')
    );

-- Multimodal Capabilities
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
        'LlamaParse Document Parsing', 
        (SELECT id FROM use_case_review.capability_categories WHERE name = 'Multimodal'), 
        ARRAY['document understanding', 'information extraction', 'smart document reader', 'data capture', 'document intelligence'],
        'Smart document reader that can understand and extract key information from complex documents including tables and images',
        ARRAY['Research paper insights generator', 'Financial report data extractor', 'Documentation analyzer'],
        'Document storage system, Document processing service, Information extraction system',
        'Reading quality depends on document clarity and formatting. May have difficulty with handwritten content or poor quality scans.',
        TRUE,
        (SELECT id FROM use_case_review.maturity_levels WHERE name = 'Beta'),
        (SELECT id FROM use_case_review.authorized_users WHERE email = 'jericho.carlos@cambridge.org'),
        (SELECT id FROM use_case_review.authorized_users WHERE email = 'jericho.carlos@cambridge.org')
    );

-- Infrastructure Capabilities
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
        'AWS Fargate for Heavy Workloads', 
        (SELECT id FROM use_case_review.capability_categories WHERE name = 'Infrastructure'), 
        ARRAY['high-performance computing', 'automated processing', 'scalable processing', 'AI task handling', 'cloud processing'],
        'Cloud-based system for handling demanding computational tasks without needing to maintain physical servers',
        ARRAY['Bulk data processing solutions', 'AI model training systems', 'Large-scale data transformation tools'],
        'Amazon Web Services account, Technical configuration, Processing workflows',
        'Cost increases with higher usage. May take time to start up when not recently used.',
        TRUE,
        (SELECT id FROM use_case_review.maturity_levels WHERE name = 'Mature'),
        (SELECT id FROM use_case_review.authorized_users WHERE email = 'jericho.carlos@cambridge.org'),
        (SELECT id FROM use_case_review.authorized_users WHERE email = 'jericho.carlos@cambridge.org')
    ),
    (
        'AWS Lambda for Light Workloads', 
        (SELECT id FROM use_case_review.capability_categories WHERE name = 'Infrastructure'), 
        ARRAY['automated tasks', 'event-based processing', 'responsive computing', 'lightweight automations', 'cloud functions'],
        'Cloud service that automatically runs specific tasks in response to events or triggers without requiring dedicated servers',
        ARRAY['Automated notification systems', 'User-action response handlers', 'Scheduled data updates', 'System integrations'],
        'Amazon Web Services account, Task definitions, Event trigger setup',
        'Best for shorter tasks under 15 minutes. Not suitable for very complex or resource-intensive operations.',
        TRUE,
        (SELECT id FROM use_case_review.maturity_levels WHERE name = 'Mature'),
        (SELECT id FROM use_case_review.authorized_users WHERE email = 'jericho.carlos@cambridge.org'),
        (SELECT id FROM use_case_review.authorized_users WHERE email = 'jericho.carlos@cambridge.org')
    );

-- Database Capabilities
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
        'PostgreSQL on AWS RDS', 
        (SELECT id FROM use_case_review.capability_categories WHERE name = 'Infrastructure'), 
        ARRAY['secure data storage', 'information management', 'user data handling', 'business records', 'cloud database'],
        'Managed cloud database system for storing business information securely with automatic backups and scalability',
        ARRAY['Customer information systems', 'Order and transaction tracking', 'User account management', 'Product catalogs'],
        'Amazon Web Services account, Data organization plan, Connection setup, Security settings',
        'Costs increase with more storage and processing power. Performance optimization requires specialized knowledge.',
        TRUE,
        (SELECT id FROM use_case_review.maturity_levels WHERE name = 'Mature'),
        (SELECT id FROM use_case_review.authorized_users WHERE email = 'jericho.carlos@cambridge.org'),
        (SELECT id FROM use_case_review.authorized_users WHERE email = 'jericho.carlos@cambridge.org')
    );

-- Development Tools Capabilities
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
        'Python Development', 
        (SELECT id FROM use_case_review.capability_categories WHERE name = 'Development Tools'), 
        ARRAY['data analysis', 'AI solution building', 'backend development', 'scientific computing'],
        'Development using Python programming language for creating powerful data processing, AI, and automation solutions',
        ARRAY['Data analysis tools', 'AI model integrations', 'Automated processing systems'],
        'Python development skills, Scientific libraries, Testing frameworks',
        'May require specialized knowledge for complex data processing. Performance can be slower for certain high-demand applications.',
        TRUE,
        (SELECT id FROM use_case_review.maturity_levels WHERE name = 'Mature'),
        (SELECT id FROM use_case_review.authorized_users WHERE email = 'jericho.carlos@cambridge.org'),
        (SELECT id FROM use_case_review.authorized_users WHERE email = 'jericho.carlos@cambridge.org')
    ),
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
    ),
    (
        'TypeScript Development', 
        (SELECT id FROM use_case_review.capability_categories WHERE name = 'Development Tools'), 
        ARRAY['web application creation', 'user interface development', 'interactive experiences', 'business applications'],
        'Development using TypeScript programming language for creating robust, maintainable web and business applications with modern interfaces',
        ARRAY['Web applications', 'Interactive dashboards', 'User-friendly management tools'],
        'Web development skills, Frontend frameworks, Testing tools',
        'Requires web development expertise. May involve managing complex dependencies and browser compatibility issues.',
        TRUE,
        (SELECT id FROM use_case_review.maturity_levels WHERE name = 'Mature'),
        (SELECT id FROM use_case_review.authorized_users WHERE email = 'jericho.carlos@cambridge.org'),
        (SELECT id FROM use_case_review.authorized_users WHERE email = 'jericho.carlos@cambridge.org')
    ),
    (
        'n8n for Quick Prototyping', 
        (SELECT id FROM use_case_review.capability_categories WHERE name = 'Development Tools'), 
        ARRAY['process automation', 'visual workflow builder', 'system connection', 'rapid solution creation'],
        'Visual tool for quickly connecting different systems and automating workflows without extensive programming knowledge',
        ARRAY['Business process automation demos', 'System integration previews', 'Data flow proof-of-concepts'],
        'Automation platform, Connection points to other systems, Basic configuration knowledge',
        'Limited scalability for production workloads. Complex business logic may eventually require custom development.',
        TRUE,
        (SELECT id FROM use_case_review.maturity_levels WHERE name = 'Beta'),
        (SELECT id FROM use_case_review.authorized_users WHERE email = 'jericho.carlos@cambridge.org'),
        (SELECT id FROM use_case_review.authorized_users WHERE email = 'jericho.carlos@cambridge.org')
    );

-- Agent Systems Capabilities
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
        'Microsoft Copilot Ecosystem', 
        (SELECT id FROM use_case_review.capability_categories WHERE name = 'Agent Systems'), 
        ARRAY['workplace AI assistant', 'Microsoft productivity tools', 'Teams AI', 'Office AI', 'digital assistant'],
        'AI assistant that works within Microsoft tools like Teams and Office to help with everyday tasks and boost productivity',
        ARRAY['Meeting summary creator', 'Document writing assistant', 'Email draft helper', 'Schedule management assistant'],
        'Microsoft 365 licenses, Copilot subscription, Organization settings, Data access permissions',
        'Requires subscription fees. Features limited to what Microsoft has implemented and company security policies.',
        TRUE,
        (SELECT id FROM use_case_review.maturity_levels WHERE name = 'Prototype'),
        (SELECT id FROM use_case_review.authorized_users WHERE email = 'jericho.carlos@cambridge.org'),
        (SELECT id FROM use_case_review.authorized_users WHERE email = 'jericho.carlos@cambridge.org')
    );

-- Integration Pipeline Capabilities
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
        'Query with Your Own Documents System', 
        (SELECT id FROM use_case_review.capability_categories WHERE name = 'Knowledge Management'), 
        ARRAY['document search', 'smart search', 'knowledge retrieval', 'document Q&A', 'document intelligence'],
        'System that allows users to ask questions about their own documents and receive accurate answers with relevant context',
        ARRAY['Company policy assistant', 'Research document helper', 'Intelligent document search'],
        'Document collection, Document processing system, Search technology, AI language model',
        'Answer quality depends on document clarity and completeness. May have difficulty with highly technical content or poorly formatted documents.',
        TRUE,
        (SELECT id FROM use_case_review.maturity_levels WHERE name = 'Beta'),
        (SELECT id FROM use_case_review.authorized_users WHERE email = 'jericho.carlos@cambridge.org'),
        (SELECT id FROM use_case_review.authorized_users WHERE email = 'jericho.carlos@cambridge.org')
    );

-- Evaluation Capabilities
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
        'RAGAS RAG Evaluation', 
        (SELECT id FROM use_case_review.capability_categories WHERE name = 'Evaluation'), 
        ARRAY['answer quality testing', 'information accuracy checks', 'AI response validation', 'performance measurement'],
        'Testing system that measures how well AI document search tools provide accurate, relevant, and trustworthy answers',
        ARRAY['Search result quality checker', 'AI answer comparison tool', 'Information accuracy tracker'],
        'Sample questions, Known correct answers, Testing procedures, Performance dashboard',
        'Testing effectiveness depends on the quality of example questions. Creating verified answer sets requires time and expertise.',
        TRUE,
        (SELECT id FROM use_case_review.maturity_levels WHERE name = 'Beta'),
        (SELECT id FROM use_case_review.authorized_users WHERE email = 'jericho.carlos@cambridge.org'),
        (SELECT id FROM use_case_review.authorized_users WHERE email = 'jericho.carlos@cambridge.org')
    ),
    (
        'Prompt Engineering Qualitative Testing', 
        (SELECT id FROM use_case_review.capability_categories WHERE name = 'Evaluation'), 
        ARRAY['AI behavior testing', 'quality assessment', 'safety checking', 'performance validation'],
        'Methodical process for testing how AI systems respond to different questions and scenarios to ensure quality and reliability',
        ARRAY['AI safety verification tools', 'Fairness assessment systems', 'Unexpected scenario testers'],
        'Testing scenarios, Quality standards, Evaluation guidelines, Testing team',
        'Requires human reviewers and judgment. Results can vary between different evaluators without standardized processes.',
        TRUE,
        (SELECT id FROM use_case_review.maturity_levels WHERE name = 'Prototype'),
        (SELECT id FROM use_case_review.authorized_users WHERE email = 'jericho.carlos@cambridge.org'),
        (SELECT id FROM use_case_review.authorized_users WHERE email = 'jericho.carlos@cambridge.org')
    );




-- Script 1: Get a list of all available tables in the use_case_review schema
-- This query simply lists all table names in the use_case_review schema
SELECT 
    table_name
FROM 
    information_schema.tables
WHERE 
    table_schema = 'use_case_review'
    AND table_type = 'BASE TABLE'
ORDER BY 
    table_name;

-- Script 2: Get detailed schema for a specific table (replace 'table_name_here' with your table name)
-- This query returns column details for a specific table
SELECT 
    column_name,
    data_type,
    character_maximum_length,
    column_default,
    is_nullable,
    CASE WHEN is_nullable = 'NO' THEN 'NOT NULL' ELSE 'NULL' END as null_constraint
FROM 
    information_schema.columns
WHERE 
    table_schema = 'use_case_review'
    AND table_name = 'table_name_here' -- Replace with your table name
ORDER BY 
    ordinal_position;

-- Script 3: Get full schema information for all tables (original script)
-- This query retrieves the schema of all tables in the use_case_review schema
-- It includes the table name and a list of columns with their data types and nullability
SELECT 
    t.table_name,
    array_agg(
        column_name || ' ' || data_type || 
        CASE WHEN is_nullable = 'NO' THEN ' NOT NULL' ELSE '' END
    ) as columns
FROM 
    information_schema.tables t
JOIN 
    information_schema.columns c ON t.table_name = c.table_name
WHERE 
    t.table_schema = 'use_case_review'
    AND t.table_type = 'BASE TABLE'
GROUP BY 
    t.table_name
ORDER BY 
    t.table_name;