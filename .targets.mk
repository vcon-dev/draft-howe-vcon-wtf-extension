# draft-howe-vcon-wtf-extension 
# 
versioned:
	@mkdir -p $@
.INTERMEDIATE: versioned/draft-howe-vcon-wtf-extension-00.md
versioned/draft-howe-vcon-wtf-extension-00.md: draft-howe-vcon-wtf-extension.md | versioned
	sed -e 's/draft-howe-vcon-world-transcription-format.md-date/2025-09-25/g' -e 's/draft-howe-vcon-world-transcription-format.md-latest/draft-howe-vcon-world-transcription-format.md-00/g' -e 's/draft-howe-vcon-wtf-extension-date/2025-09-25/g' -e 's/draft-howe-vcon-wtf-extension-latest/draft-howe-vcon-wtf-extension-00/g' -e '/^{::include [^\/]/{ s/^{::include /{::include draft-howe-vcon-wtf-extension-00\//; }' $< >$@
	for inc in $$(sed -ne '/^{::include [^\/]/{ s/^{::include draft-howe-vcon-wtf-extension-00\///;s/}$$//; p; }' $@); do \
	  target=draft-howe-vcon-wtf-extension-00/$$inc; \
	  mkdir -p $$(dirname "$$target"); \
	  git show "$$tag:$$inc" >"$$target" || \
	    (echo "Attempting to make a copy of $$inc"; \
	     tmp=.; \
	     make -C "$$tmp" "$$inc" && cp "$$tmp/$$inc" "$$target"; \
	  ); \
	done
