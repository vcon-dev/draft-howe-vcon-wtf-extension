# draft-howe-vcon-wtf-extension 
# draft-howe-vcon-wtf-extension-00
versioned:
	@mkdir -p $@
.INTERMEDIATE: versioned/draft-howe-vcon-wtf-extension-00.md
.SECONDARY: versioned/draft-howe-vcon-wtf-extension-00.xml
versioned/draft-howe-vcon-wtf-extension-00.md: | versioned
	git show "draft-howe-vcon-wtf-extension-00:draft-howe-vcon-wtf-extension.md" | sed -e 's/draft-howe-vcon-world-transcription-format.md-date/2025-09-25/g' -e 's/draft-howe-vcon-world-transcription-format.md-latest/draft-howe-vcon-world-transcription-format.md-00/g' -e 's/draft-howe-vcon-wtf-extension-date/2025-09-25/g' -e 's/draft-howe-vcon-wtf-extension-latest/draft-howe-vcon-wtf-extension-00/g' -e '/^{::include [^\/]/{ s/^{::include /{::include draft-howe-vcon-wtf-extension-00\//; }' >$@
	for inc in $$(sed -ne '/^{::include [^\/]/{ s/^{::include draft-howe-vcon-wtf-extension-00\///;s/}$$//; p; }' $@); do \
	  target=draft-howe-vcon-wtf-extension-00/$$inc; \
	  mkdir -p $$(dirname "$$target"); \
	  git show "$$tag:$$inc" >"$$target" || \
	    (echo "Attempting to make a copy of $$inc"; \
	     tmp=$$(mktemp -d); git clone . -b "$$tag" "$$tmp"; \
	     ln -s "$(LIBDIR)" "$$tmp/$(LIBDIR)"; \
	     make -C "$$tmp" "$$inc" && cp "$$tmp/$$inc" "$$target"; \
	     rm -rf "$$tmp"; \
	  ); \
	done
.INTERMEDIATE: versioned/draft-howe-vcon-wtf-extension-01.xml
versioned/draft-howe-vcon-wtf-extension-01.xml: draft-howe-vcon-wtf-extension.xml | versioned
	sed -e 's/draft-howe-vcon-world-transcription-format.md-date/2025-09-25/g' -e 's/draft-howe-vcon-world-transcription-format.md-latest/draft-howe-vcon-world-transcription-format.md-00/g' -e 's/draft-howe-vcon-wtf-extension-date/2025-09-25/g' -e 's/draft-howe-vcon-wtf-extension-latest/draft-howe-vcon-wtf-extension-01/g' -e 's/draft-howe-vcon-wtf-extension-date/2025-09-25/g' -e 's/draft-howe-vcon-wtf-extension-latest/draft-howe-vcon-wtf-extension-01/g' $< >$@
diff-draft-howe-vcon-wtf-extension.html: versioned/draft-howe-vcon-wtf-extension-00.txt versioned/draft-howe-vcon-wtf-extension-01.txt
	-$(iddiff) $^ > $@
