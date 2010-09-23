# This is the top-level Makefile. When creating a subdirectory for a
# new howto, create a new Makefile in that directory, referring back
# to this one. Like so:
#
# %: force
# 	@$(MAKE) -f $(top_srcdir)/Makefile $@
# force: ;
#
# That target should go after all other targets you define in your
# lower-level Makefile.

#####################################################################
# Make variables
#####################################################################

# Paths to Norm Walsh's DocBook XSL stylesheets.  
# Fetching these from the web on every run is probably dead slow, so
# make sure you have a local copy of these stylesheets installed, and
# XML catalogs set up correctly. On Debian/Ubuntu systems, this is a
# simple matter of "apt-get install docbook-xsl".
if PROFILING
HTML_STYLESHEET ?= $(STYLESHEET_PREFIX)/xhtml/profile-docbook.xsl
CHUNKED_HTML_STYLESHEET ?= $(STYLESHEET_PREFIX)/xhtml/profile-chunk.xsl
else
HTML_STYLESHEET ?= $(STYLESHEET_PREFIX)/xhtml/docbook.xsl
CHUNKED_HTML_STYLESHEET ?= $(STYLESHEET_PREFIX)/xhtml/chunk.xsl
endif
TITLEPAGE_STYLESHEET ?= $(STYLESHEET_PREFIX)/template/titlepage.xsl

# For PDF output, define some variables to be used for
# FO-to-PDF transformation
if USE_FO_TITLEPAGE
if PROFILING
FO_STYLESHEET ?= $(abs_srcdir)/stylesheets/fo/profile-docbook.xsl
else
FO_STYLESHEET ?= $(abs_srcdir)/stylesheets/fo/docbook.xsl
endif
else
if PROFILING
FO_STYLESHEET ?= $(STYLESHEET_PREFIX)/fo/profile-docbook.xsl
else
FO_STYLESHEET ?= $(STYLESHEET_PREFIX)/fo/docbook.xsl
endif
endif

#####################################################################
# Command line option sets for invoked programs
#####################################################################

# xsltproc options for HTML output
XSLTPROC_HTML_OPTIONS = --xinclude \
 --param use.id.as.filename 1 \
 --param generate.index 0 \
 --param admon.graphics 1 \
 --stringparam admon.graphics.path images/ \
 --stringparam admon.graphics.extension .png \
 --stringparam ulink.target $(ULINK_TARGET) \
 --stringparam html.stylesheet drbd-howto-collection.css \
 --stringparam graphic.default.extension png
if PROFILING
XSLTPROC_HTML_OPTIONS += $(XSLTPROC_PROFILING_OPTIONS)
endif

# xsltproc options for FO output
XSLTPROC_FO_OPTIONS =  --xinclude \
 --stringparam paper.type $(PAPER_SIZE) \
 --stringparam body.font.family "$(FO_BODY_FONT_FAMILY)" \
 --stringparam title.font.family "$(FO_TITLE_FONT_FAMILY)" \
 --stringparam insert.link.page.number yes \
 --stringparam insert.xref.page.number yes \
 --stringparam graphic.default.extension svg \
 --stringparam generate.toc "$(FO_TOC)" \
 --param use.extensions 1 \
 --param tablecolumns.extension 0 \
 --param admon.graphics 1 \
 --stringparam admon.graphics.path $(abs_srcdir)/images/ \
 --stringparam admon.graphics.extension .svg
if SECTION_NUMBERS
XSLTPROC_FO_OPTIONS += --param section.autolabel 1 \
 --param section.autolabel.max.depth 2 \
 --param section.label.includes.component.label 1
endif
if PROFILING
XSLTPROC_FO_OPTIONS += $(XSLTPROC_PROFILING_OPTIONS)
endif
if USE_FOP
XSLTPROC_FO_OPTIONS += --param fop1.extensions 1
endif

#####################################################################
# Targets for individual document types
#####################################################################

# XML from asciidoc
if ASCIIDOC_SUPPORT
%.xml: %.$(ASCIIDOC_EXTENSION)
	$(ASCIIDOC) --out-file=$@ \
	--backend=docbook --doctype=article $<
endif

# Multiple-page HTML (from XML)
if XSLT
%.html: %.xml
	$(XSLTPROC) \
	$(XSLTPROC_HTML_OPTIONS) \
	--stringparam root.filename $* \
	$(CHUNKED_HTML_STYLESHEET) $< 
endif

# FO (from XML)
if XSLT
if USE_FO_TITLEPAGE
%.fo: %.xml stylesheets/fo/titlepage.xsl
else
%.fo: %.xml
endif
	$(XSLTPROC) -o $@ \
	$(XSLTPROC_FO_OPTIONS) \
	$(FO_STYLESHEET) $<
endif

# OpenDocument Text (from XML)
if RENDER_ODT
%.odt: %.xml
	$(DOCBOOK2ODF) --force $< --output-file $@
endif

# PDF (from FO)
if RENDER_PDF
if USE_DBLATEX
%.pdf: %.xml
else
%.pdf: %.fo
endif
if USE_FOP
	$(FOP) $(FOP_OPTIONS) $< -pdf $@
endif
if USE_XMLROFF
	$(XMLROFF) --backend=$(XMLROFF_BACKEND) --format=pdf -o $@ $<
endif
if USE_DBLATEX
	$(DBLATEX) --backend=$(DBLATEX_BACKEND) --pdf --output=$@ $<
endif
endif

# PostScript (from FO)
if RENDER_PS
if USE_DBLATEX
%.ps: %.xml
else
%.ps: %.fo
endif
if USE_FOP
	$(FOP) $(FOP_OPTIONS) $< -pdf $@
endif
if USE_XMLROFF
	$(XMLROFF) --backend=$(XMLROFF_BACKEND) --format=ps -o $@ $<
endif
if USE_DBLATEX
	$(DBLATEX) --backend=$(DBLATEX_BACKEND) --ps --output=$@ $<
endif
endif

#####################################################################
# Targets for other file types
#####################################################################

# Generated images: SVG from MathML
# (needed for HTML output, and PDF if using FOP)
# The ugly sed hack is because batik (used by FOP) complains about
# 'svg version="1"', while 'svg version="1.0"' is OK.
if RENDER_MML
%.svg: %.mml
	$(MATHMLSVG) --font-size=24 $< 
	$(SED)-i -e 's/<svg version="1"/<svg version="1.0"/' $@
endif

# Generated images: Encapsulated PostScript from SVG
if USE_INKSCAPE
%.eps: %.svg
	$(INKSCAPE) --file=$< --export-area-drawing --export-eps=$@
endif

# Generated images: PNG from SVG
# (needed for HTML output)
if RENDER_SVG
%.png: %.svg
if USE_INKSCAPE
	$(INKSCAPE) --file=$< --export-dpi=90 --export-area-drawing --export-png=$@
endif
if USE_RSVG
	$(RSVG) --dpi-x=90 --dpi-y=90 --format=png $< $@
endif

# Half-size SVG (from PNG)
%-small.png: %.svg
if USE_INKSCAPE
	$(INKSCAPE) --file=$< --export-dpi=45 --export-area-drawing --export-png=$@
endif
if USE_RSVG
	$(RSVG) --dpi-x=45 --dpi-y=45 --format=png $< $@
endif

# Double-size SVG (from PNG)
%-large.png: %.svg
if USE_INKSCAPE
	$(INKSCAPE) --file=$< --export-dpi=180 --export-area-drawing --export-png=$@
endif
if USE_RSVG
	$(RSVG) --dpi-x=180 --dpi-y=180 --format=png $< $@
endif
endif

#####################################################################
# Miscellaneous targets
#####################################################################

# Title page layout (currently only used for FOP-generated PDF)
if USE_FO_TITLEPAGE
stylesheets/fo/titlepage.xsl: $(FO_TITLEPAGE)
	$(XSLTPROC) -o $@ \
	--xinclude $(TITLEPAGE_STYLESHEET) $<
endif

# A timestamp file. Holds the date at the time of the invocation
builddate:
	env LC_ALL=C date +"%B %d, %Y" > $@	

