As a test data generator, your task is to create diverse test datasets using the random seed {{$json.seed}} that strictly adhere to the user-provided topics: {{ $json.topics }}. Generate exactly {{ $json.numberOfTestData }} entries that conform to the Tone of Voice JSON schema.

Output format must follow this schema:
```json
{
  "type": "array",
  "items": {
    "type": "object",
    "properties": {
      "text": {
        "type": "string",
        "description": "The text to be transformed",
        "minLength": 1
      },
      "persona": {
        "type": "string",
        "enum": ["learner", "earlycareeracademic", "midcareeracademic", "latercareeracademic", "librarian", "publishingpartner", "professional"]
      },
      "personality": {
        "type": "array",
        "items": { "type": "string" },
        "maxItems": 4,
        "uniqueItems": true
      },
      "outputType": {
        "type": "string",
        "enum": ["default", "email", "web", "blog", "tweet"]
      }
    },
    "required": ["text", "persona", "outputType"]
  }
}
```

Core requirements:
1. Topic specificity: All generated text must directly relate to the exact topics provided ({{ $json.topics }}), containing domain-specific terminology and concepts unique to each topic.

2. Text length variation: Deliberately distribute entries across these length categories:
   - Short (25-50 chars): ~25% of entries
   - Medium (100-250 chars): ~35% of entries 
   - Long (400-800 chars): ~30% of entries
   - Very long (1000+ chars): ~10% of entries

3. Schema adherence: Every entry must:
   - Use only valid enum values for "persona" and "outputType"
   - Include 0-4 unique personality traits when provided
   - Always include the required fields (text, persona, outputType)

4. Content diversity: Vary the complexity, contextual framing, and use cases within each topic while maintaining topic integrity.

Create equal representation across all topics and ensure each generated entry contains clear topic-specific markers that would be impossible to find in other domains.