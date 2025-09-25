# vCon World Transcription Format Extension

This repository contains the Internet-Draft for the vCon World Transcription Format (WTF) Extension.

## About

The World Transcription Format (WTF) extension for Virtualized Conversations (vCon) provides a standardized method for representing speech-to-text transcription data from multiple providers within vCon containers. This extension enables consistent transcription storage, analysis, and interoperability across different transcription services while preserving provider-specific features through extensible fields.

## Draft Information

- **Title**: vCon World Transcription Format Extension
- **Abbreviation**: vCon WTF Extension
- **Category**: Standards Track
- **Working Group**: vCon
- **Author**: Thomas McCarthy-Howe (Strolid)

## Repository Structure

- `draft-howe-vcon-wtf-extension-00.md` - The main Internet-Draft document
- `.github/workflows/` - GitHub Actions workflows for building and publishing the draft
- `template/` - Original template files (can be removed after setup)

## Building the Draft

This repository uses the [i-d-template](https://github.com/martinthomson/i-d-template) system for building Internet-Drafts. The GitHub Actions workflows will automatically:

1. Build the draft in multiple formats (HTML, PDF, TXT)
2. Publish to GitHub Pages
3. Update venue information
4. Handle versioning

## Local Development

To build the draft locally, you can use the i-d-template system:

```bash
# Clone the i-d-template repository
git clone https://github.com/martinthomson/i-d-template.git lib

# Build the draft
make -f lib/Makefile

# View the built draft
open draft-howe-vcon-wtf-extension-latest.html
```

## Contributing

This is an individual Internet-Draft. For questions or suggestions, please contact the author at ghostofbasho@gmail.com.

## License

This document is subject to BCP 78 and the IETF Trust's Legal Provisions Relating to IETF Documents.
