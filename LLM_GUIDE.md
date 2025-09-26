# LLM Protocol Guide: vCon World Transcription Format (WTF) Extension

## Purpose

This guide enables LLM tools (like Cursor, ChatGPT, Claude, etc.) to correctly understand, process, and work with the vCon World Transcription Format (WTF) Extension. The WTF extension provides a standardized way to represent speech-to-text transcription data from multiple providers within vCon containers.

## Official Specifications

- **vCon WTF Extension Draft**: [draft-howe-vcon-wtf-extension-latest](https://vcon-dev.github.io/draft-howe-vcon-wtf-extension/draft-howe-vcon-wtf-extension-latest.html)
- **vCon Core Specification**: [draft-ietf-vcon-core-00](https://datatracker.ietf.org/doc/draft-ietf-vcon-core-00/)
- **vCon Overview**: [draft-ietf-vcon-overview-00](https://datatracker.ietf.org/doc/draft-ietf-vcon-overview-00/)
- **GitHub Repository**: [vcon-dev/draft-howe-vcon-wtf-extension](https://github.com/vcon-dev/draft-howe-vcon-wtf-extension)
- **vCon Working Group**: [vcon@ietf.org](mailto:vcon@ietf.org) | [Mail Archive](https://mailarchive.ietf.org/arch/browse/vcon/)

## Related RFCs and Standards

- **RFC 2119**: [Key words for use in RFCs to Indicate Requirement Levels](https://www.rfc-editor.org/rfc/rfc2119.html)
- **RFC 8174**: [Ambiguity of Uppercase vs Lowercase in RFC 2119 Key Words](https://www.rfc-editor.org/rfc/rfc8174.html)
- **RFC 3339**: [Date and Time on the Internet: Timestamps](https://www.rfc-editor.org/rfc/rfc3339.html)
- **RFC 5646 (BCP 47)**: [Tags for Identifying Languages](https://www.rfc-editor.org/rfc/rfc5646.html)
- **RFC 8949**: [Concise Binary Object Representation (CBOR)](https://www.rfc-editor.org/rfc/rfc8949.html)

## Protocol Overview

The World Transcription Format (WTF) is a standardized JSON schema that enables:
- **Unified transcription representation** across different speech-to-text providers
- **Hierarchical organization** from words to segments to complete transcripts
- **Provider-agnostic processing** while preserving provider-specific features
- **Quality metrics and confidence scoring** for transcription reliability
- **Speaker diarization** for multi-speaker conversations

## Core Protocol Concepts

### 1. vCon Container Structure
A vCon (Virtualized Conversation) is a standardized container for conversation data that includes:
- **Parties**: Participants in the conversation
- **Dialog**: Communication sessions (calls, meetings, etc.)
- **Attachments**: Additional data like transcriptions, recordings, etc.

### 2. WTF Extension as Attachment
The WTF transcription data is stored as a vCon attachment with:
- **Type**: `"wtf_transcription"`
- **Encoding**: `"json"`
- **Body**: The structured WTF transcription data

### 3. Hierarchical Data Structure
WTF organizes transcription data in three levels:
- **Transcript**: High-level summary (complete text, language, duration, confidence)
- **Segments**: Logical chunks (sentences/phrases with timing and speaker info)
- **Words**: Individual words with precise timing and confidence

## Core WTF Schema Structure

```json
{
  "transcript": {
    "text": "Complete transcription text",
    "language": "en-US",
    "duration": 65.2,
    "confidence": 0.92
  },
  "segments": [
    {
      "id": 0,
      "start": 0.5,
      "end": 4.8,
      "text": "Segment text content",
      "confidence": 0.95,
      "speaker": 0,
      "words": [0, 1, 2, 3, 4]
    }
  ],
  "words": [
    {
      "id": 0,
      "start": 0.5,
      "end": 0.8,
      "text": "Hello",
      "confidence": 0.98,
      "speaker": 0,
      "is_punctuation": false
    }
  ],
  "metadata": {
    "created_at": "2025-01-02T12:15:30Z",
    "processed_at": "2025-01-02T12:16:35Z",
    "provider": "deepgram",
    "model": "nova-2",
    "processing_time": 12.5,
    "audio": {
      "duration": 65.2,
      "sample_rate": 8000,
      "channels": 1,
      "format": "wav"
    }
  },
  "speakers": {
    "0": {
      "id": 0,
      "label": "Alice (Customer Service)",
      "segments": [0],
      "total_time": 4.3,
      "confidence": 0.95
    }
  },
  "quality": {
    "audio_quality": "high",
    "background_noise": 0.1,
    "multiple_speakers": true,
    "overlapping_speech": false,
    "silence_ratio": 0.15,
    "average_confidence": 0.92,
    "low_confidence_words": 0
  },
  "extensions": {
    "provider_name": {
      "provider_specific_data": "value"
    }
  }
}
```

## Protocol Usage Patterns

### Pattern 1: Identifying WTF Transcriptions in vCon Files

**When to use**: When processing vCon files to find transcription data

**Protocol Rules**:
- Look for attachments with `type: "wtf_transcription"`
- The attachment body contains the WTF JSON structure
- Multiple WTF attachments may exist (e.g., from different providers)

**Data Access Pattern**:
```
vCon.attachments[] → filter by type="wtf_transcription" → attachment.body
```

### Pattern 2: Extracting Core Transcription Information

**When to use**: When you need the main transcription content

**Protocol Rules**:
- `transcript.text` contains the complete transcription
- `transcript.language` uses BCP-47 format (e.g., "en-US", "es-MX")
- `transcript.confidence` is normalized to [0.0, 1.0] range
- `transcript.duration` is in floating-point seconds

**Required Fields**:
- `transcript.text` (string)
- `transcript.language` (string, BCP-47)
- `transcript.duration` (number, >= 0)
- `transcript.confidence` (number, 0.0-1.0)

### Pattern 3: Working with Segmented Content

**When to use**: When you need time-aligned segments or speaker information

**Protocol Rules**:
- `segments[]` contains logical chunks of transcribed content
- Each segment has `start` and `end` times in seconds
- `speaker` field can be integer (0, 1, 2) or string ("Speaker A")
- `words` array references word indices (if words array exists)

**Segment Structure**:
```
segments[i] = {
  id: integer (unique within document),
  start: number (seconds),
  end: number (seconds, > start),
  text: string (trimmed),
  confidence: number (0.0-1.0),
  speaker: integer|string (optional),
  words: [integer] (optional, word indices)
}
```

### Pattern 4: Accessing Word-Level Details

**When to use**: When you need precise timing or word-level confidence

**Protocol Rules**:
- `words[]` is optional but provides word-level granularity
- Each word has precise start/end timing
- `is_punctuation` indicates if word is punctuation
- Word IDs are referenced by segments

**Word Structure**:
```
words[i] = {
  id: integer (unique within document),
  start: number (seconds),
  end: number (seconds, > start),
  text: string,
  confidence: number (0.0-1.0),
  speaker: integer|string (optional),
  is_punctuation: boolean (optional)
}
```

### Pattern 5: Speaker Diarization Information

**When to use**: When analyzing multi-speaker conversations

**Protocol Rules**:
- `speakers{}` object maps speaker IDs to speaker information
- Speaker IDs match those used in segments and words
- `total_time` indicates speaking duration per speaker
- `segments` array lists segment IDs for each speaker

**Speaker Structure**:
```
speakers[speaker_id] = {
  id: integer|string,
  label: string (human-readable name),
  segments: [integer] (segment IDs),
  total_time: number (seconds),
  confidence: number (0.0-1.0)
}
```

### Pattern 6: Quality Assessment

**When to use**: When evaluating transcription reliability

**Protocol Rules**:
- `quality{}` object provides assessment metrics
- `audio_quality` is categorical: "high", "medium", "low"
- `background_noise` is normalized [0.0, 1.0]
- `average_confidence` is mean confidence across content
- `low_confidence_words` is count of words below 0.5 confidence

**Quality Metrics**:
```
quality = {
  audio_quality: "high"|"medium"|"low",
  background_noise: number (0.0-1.0),
  multiple_speakers: boolean,
  overlapping_speech: boolean,
  silence_ratio: number (0.0-1.0),
  average_confidence: number (0.0-1.0),
  low_confidence_words: integer,
  processing_warnings: [string]
}
```

### Pattern 7: Provider-Specific Extensions

**When to use**: When you need provider-specific features or metadata

**Protocol Rules**:
- `extensions{}` preserves provider-specific data
- Key is provider name (lowercase)
- Content varies by provider
- Always check for provider existence before accessing

**Common Provider Extensions**:
```
extensions = {
  "whisper": {
    temperature: number,
    compression_ratio: number,
    avg_logprob: number,
    no_speech_prob: number
  },
  "deepgram": {
    utterances: [object],
    paragraphs: [object],
    search_terms: [string]
  }
}
```

### Pattern 8: Metadata and Processing Information

**When to use**: When you need to understand how the transcription was created

**Protocol Rules**:
- `metadata{}` contains processing and source information
- `created_at` and `processed_at` use ISO 8601 format
- `provider` is lowercase identifier
- `model` is provider's model identifier
- `audio{}` contains source audio information

**Metadata Structure**:
```
metadata = {
  created_at: string (ISO 8601),
  processed_at: string (ISO 8601),
  provider: string (lowercase),
  model: string,
  processing_time: number (seconds, optional),
  audio: {
    duration: number (seconds),
    sample_rate: integer (Hz, optional),
    channels: integer (optional),
    format: string (optional),
    bitrate: integer (kbps, optional)
  },
  options: object (provider-specific)
}
```

## Protocol Rules and Constraints

### 1. Required vs Optional Fields

**Always Required**:
- `transcript.text` - Complete transcription text
- `transcript.language` - BCP-47 language code
- `transcript.duration` - Audio duration in seconds (>= 0)
- `transcript.confidence` - Overall confidence (0.0-1.0)
- `segments[]` - Array of segment objects
- `metadata.created_at` - ISO 8601 timestamp
- `metadata.processed_at` - ISO 8601 timestamp
- `metadata.provider` - Provider identifier (lowercase)
- `metadata.model` - Model identifier

**Always Optional**:
- `words[]` - Word-level details
- `speakers{}` - Speaker diarization
- `quality{}` - Quality metrics
- `extensions{}` - Provider-specific data
- `alternatives[]` - Alternative transcriptions
- `enrichments{}` - Analysis features
- `streaming{}` - Streaming information

### 2. Data Type Constraints

**Confidence Scores**:
- MUST be normalized to [0.0, 1.0] range
- 1.0 = highest confidence, 0.0 = lowest confidence
- Provider-specific scales must be converted during import

**Timestamps**:
- MUST be floating-point seconds
- `end` time MUST be greater than `start` time
- Precision should be sufficient for word-level timing

**Language Codes**:
- MUST use BCP-47 format (e.g., "en-US", "es-MX", "fr-CA")
- Case-sensitive, hyphen-separated
- Include region when available

**Speaker IDs**:
- Can be integer (0, 1, 2) or string ("Speaker A")
- MUST be consistent within a single WTF document
- MUST match between segments, words, and speakers objects

### 3. Validation Rules

**Structure Validation**:
- Check for required fields before processing
- Validate confidence scores are in [0, 1] range
- Ensure segment IDs are unique within document
- Verify word IDs are unique within document
- Check that referenced word IDs exist in words array

**Content Validation**:
- Verify transcript.text matches concatenated segment text
- Check that segment timing doesn't exceed audio duration
- Validate speaker IDs are consistent across objects
- Ensure language code follows BCP-47 format

### 4. Error Handling Patterns

**Missing Fields**:
- Provide sensible defaults for optional fields
- Log warnings for missing optional data
- Fail gracefully for missing required fields

**Malformed Data**:
- Clamp confidence scores to [0, 1] range
- Handle null/undefined values gracefully
- Validate data types before processing

**Provider Variations**:
- Check for provider-specific extensions before accessing
- Handle different confidence score scales
- Adapt to provider-specific field names

## Common Protocol Issues

### 1. Confidence Score Normalization
**Issue**: Different providers use different confidence scales
**Protocol Rule**: All confidence scores MUST be normalized to [0.0, 1.0] range
**Solution**: Convert provider-specific scales during import/processing

### 2. Timestamp Precision
**Issue**: Timestamp precision varies between providers
**Protocol Rule**: Use floating-point seconds consistently
**Solution**: Maintain sufficient precision for word-level timing

### 3. Speaker ID Consistency
**Issue**: Speaker IDs may be integers or strings
**Protocol Rule**: Speaker IDs MUST be consistent within a single WTF document
**Solution**: Handle both types and maintain consistency across all objects

### 4. Language Code Validation
**Issue**: Language codes may not follow BCP-47 format
**Protocol Rule**: Language codes MUST use BCP-47 format
**Solution**: Validate and normalize language codes to BCP-47 standard

### 5. Missing Optional Fields
**Issue**: Optional fields may be missing or null
**Protocol Rule**: Optional fields are truly optional
**Solution**: Always check for field existence and provide sensible defaults

## LLM Usage Guidelines

### When Processing WTF Data

1. **Always validate structure first** - Check for required fields
2. **Handle optional fields gracefully** - Don't assume they exist
3. **Respect confidence scores** - Use them to assess reliability
4. **Preserve timing information** - Don't lose temporal relationships
5. **Maintain speaker consistency** - Keep speaker IDs consistent
6. **Check provider extensions** - Access provider-specific data when needed

### When Creating WTF Data

1. **Follow the schema exactly** - Use correct field names and types
2. **Normalize confidence scores** - Convert to [0.0, 1.0] range
3. **Use proper timestamps** - Floating-point seconds
4. **Include required metadata** - Provider, model, timestamps
5. **Preserve provider data** - Store in extensions field
6. **Validate before output** - Ensure data integrity

### When Analyzing WTF Data

1. **Consider confidence levels** - Weight analysis by confidence
2. **Use timing information** - Leverage temporal relationships
3. **Respect speaker boundaries** - Don't mix speaker contexts
4. **Check quality metrics** - Use quality data for analysis
5. **Handle multiple providers** - Compare across different sources
6. **Preserve original data** - Don't modify source WTF data

## Security and Privacy Best Practices

### Data Protection
1. **Handle sensitive data carefully** - Transcription data often contains personal information
2. **Implement access controls** - Restrict access to WTF transcription attachments
3. **Consider encryption** - Encrypt transcription data at rest and in transit
4. **Follow data retention policies** - Implement policies consistent with privacy regulations
5. **Support data redaction** - Provide mechanisms for anonymizing sensitive content

### Integrity and Validation
1. **Validate timestamps** - Ensure transcription timing matches dialog timing
2. **Check data integrity** - Use vCon signing mechanisms when available
3. **Verify provider credentials** - Validate external transcription provider security
4. **Use secure communication** - Implement TLS 1.2 or higher for provider APIs
5. **Audit data handling** - Review provider compliance and data practices

## Performance and Scalability Considerations

### Large Transcription Handling
1. **Process in chunks** - Handle large transcriptions incrementally
2. **Stream when possible** - Use streaming information for real-time processing
3. **Cache frequently accessed data** - Store processed results for reuse
4. **Optimize memory usage** - Don't load entire large transcriptions into memory
5. **Use appropriate data structures** - Choose efficient data structures for your use case

### Multi-Provider Processing
1. **Compare results** - Analyze differences between provider transcriptions
2. **Weight by confidence** - Use confidence scores to determine best results
3. **Handle provider failures** - Implement fallback mechanisms
4. **Batch processing** - Process multiple transcriptions efficiently
5. **Monitor performance** - Track processing times and resource usage

## Provider-Specific Considerations

### Supported Providers
The WTF extension supports these major transcription providers:
- **Whisper** (OpenAI) - Open-source speech recognition
- **Deepgram** - Real-time speech-to-text API
- **AssemblyAI** - AI-powered transcription and audio intelligence
- **Google Cloud Speech-to-Text** - Google's speech recognition service
- **Amazon Transcribe** - AWS speech-to-text service
- **Azure Speech Services** - Microsoft's speech recognition platform
- **Rev.ai** - Automated and human transcription services
- **Speechmatics** - Real-time and batch speech recognition
- **Wav2Vec2** (Meta) - Self-supervised speech recognition
- **Parakeet** (NVIDIA) - Speech recognition toolkit

### Provider Conversion Rules
1. **Normalize confidence scores** - Convert to [0.0, 1.0] range
2. **Convert timestamps** - Use floating-point seconds
3. **Standardize language codes** - Use BCP-47 format
4. **Preserve provider features** - Store in extensions field
5. **Validate output** - Ensure compliance with WTF schema

## Error Handling and Recovery

### Graceful Degradation
1. **Handle missing fields** - Provide sensible defaults for optional data
2. **Recover from malformed data** - Implement robust parsing with fallbacks
3. **Log errors appropriately** - Record issues without exposing sensitive data
4. **Provide user feedback** - Inform users of data quality issues
5. **Implement retry logic** - Handle transient failures gracefully

### Data Quality Issues
1. **Detect low confidence** - Flag transcriptions with poor quality
2. **Handle timing inconsistencies** - Resolve timestamp conflicts
3. **Manage speaker ID mismatches** - Resolve speaker identification issues
4. **Process warnings** - Handle processing_warnings from quality metrics
5. **Validate cross-references** - Ensure word IDs match between segments and words

## Conclusion

The vCon World Transcription Format (WTF) Extension provides a robust, standardized protocol for handling transcription data from multiple providers. This guide enables LLM tools to:

1. **Understand the protocol structure** - Know how WTF data is organized and accessed
2. **Follow protocol rules** - Adhere to data type constraints and validation requirements
3. **Handle provider variations** - Work with different transcription services consistently
4. **Process data correctly** - Extract information while preserving data integrity
5. **Avoid common pitfalls** - Handle edge cases and malformed data gracefully

The hierarchical structure of WTF makes it suitable for various use cases, from simple text extraction to complex multi-speaker analysis. The extensible design ensures compatibility with current and future transcription providers while maintaining a consistent interface for LLM processing.

**Key Protocol Takeaways**:
- WTF is a JSON schema with required and optional fields
- Confidence scores are normalized to [0.0, 1.0] range
- Timestamps use floating-point seconds
- Language codes follow BCP-47 format
- Speaker IDs must be consistent within a document
- Provider-specific data is preserved in extensions

For complete technical details, refer to the Internet-Draft specification document.

## References

### Primary Specifications
- [draft-howe-vcon-wtf-extension-latest](https://vcon-dev.github.io/draft-howe-vcon-wtf-extension/draft-howe-vcon-wtf-extension-latest.html) - vCon World Transcription Format Extension
- [draft-ietf-vcon-core-00](https://datatracker.ietf.org/doc/draft-ietf-vcon-core-00/) - Virtualized Conversation (vCon) Container
- [draft-ietf-vcon-overview-00](https://datatracker.ietf.org/doc/draft-ietf-vcon-overview-00/) - The vCon - Conversation Data Container - Overview

### Standards and RFCs
- [RFC 2119](https://www.rfc-editor.org/rfc/rfc2119.html) - Key words for use in RFCs to Indicate Requirement Levels
- [RFC 3339](https://www.rfc-editor.org/rfc/rfc3339.html) - Date and Time on the Internet: Timestamps
- [RFC 5646](https://www.rfc-editor.org/rfc/rfc5646.html) - Tags for Identifying Languages (BCP 47)
- [RFC 8949](https://www.rfc-editor.org/rfc/rfc8949.html) - Concise Binary Object Representation (CBOR)

### Community Resources
- [vCon Working Group](https://datatracker.ietf.org/wg/vcon/) - IETF Working Group
- [vCon GitHub Organization](https://github.com/vcon-dev) - Development repositories
- [vCon Mail Archive](https://mailarchive.ietf.org/arch/browse/vcon/) - Working group discussions
