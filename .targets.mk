# draft-howe-vcon-wtf-extension 
# 
versioned:
	@mkdir -p $@
.INTERMEDIATE: versioned/draft-howe-vcon-wtf-extension-00.xml
versioned/draft-howe-vcon-wtf-extension-00.xml: draft-howe-vcon-wtf-extension.xml | versioned
	sed -e 's/draft-howe-vcon-world-transcription-format.md-date/2025-09-25/g' -e 's/draft-howe-vcon-world-transcription-format.md-latest/draft-howe-vcon-world-transcription-format.md-00/g' -e 's/draft-howe-vcon-wtf-extension-date/2025-09-25/g' -e 's/draft-howe-vcon-wtf-extension-latest/draft-howe-vcon-wtf-extension-00/g' -e 's/draft-howe-vcon-wtf-extension-date/2025-09-25/g' -e 's/draft-howe-vcon-wtf-extension-latest/draft-howe-vcon-wtf-extension-00/g' $< >$@
