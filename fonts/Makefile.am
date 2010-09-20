# Some useful wildcard expansions
TTF_FILES ?= $(wildcard *.ttf)

if FONT_METRICS_TTF
xml: $(TTF_FILES:.ttf=.xml)

%.xml: %.ttf
	$(FOP_TTFREADER) $< $@
endif
