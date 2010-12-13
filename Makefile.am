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
if HTML_CHUNK
HTML_STYLESHEET ?= $(STYLESHEET_PREFIX)/$(HTML_FLAVOR)/profile-chunk.xsl
else
HTML_STYLESHEET ?= $(STYLESHEET_PREFIX)/$(HTML_FLAVOR)/profile-docbook.xsl
endif
else
if HTML_CHUNK
HTML_STYLESHEET ?= $(STYLESHEET_PREFIX)/$(HTML_FLAVOR)/chunk.xsl
else
HTML_STYLESHEET ?= $(STYLESHEET_PREFIX)/$(HTML_FLAVOR)/docbook.xsl
endif
endif

# Stylesheet for creating a titlepage stylesheet from titlepage
# template
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
XSLTPROC_OPTIONS = --xinclude \
 --param admon.graphics 1 \
 --stringparam l10n.gentext.default.language $(DEFAULT_LANGUAGE)
if DRAFT_MODE
XSLTPROC_OPTIONS += --stringparam draft.mode yes
endif
if COMMENTS
XSLTPROC_OPTIONS += --param show.comments 1
else
XSLTPROC_OPTIONS += --param show.comments 0
endif
if SYNTAX_HIGHLIGHTING
XSLTPROC_OPTIONS += --param highlight.source 1
endif
if SECTION_NUMBERS
XSLTPROC_OPTIONS += --param section.autolabel 1 \
 --param section.autolabel.max.depth $(SECTION_NUMBER_DEPTH) \
 --param section.label.includes.component.label 1
endif

# xsltproc options for HTML output
XSLTPROC_HTML_OPTIONS = $(XSLTPROC_OPTIONS) \
 --param use.id.as.filename 1 \
 --param generate.index 0 \
 --stringparam admon.graphics.path images/ \
 --stringparam admon.graphics.extension .png \
 --stringparam ulink.target $(ULINK_TARGET) \
 --stringparam html.stylesheet $(CSS) \
 --stringparam graphic.default.extension png
if PROFILING
XSLTPROC_HTML_OPTIONS += $(XSLTPROC_PROFILING_OPTIONS)
endif

# xsltproc options for FO output
XSLTPROC_FO_OPTIONS =  $(XSLTPROC_OPTIONS) \
 --stringparam paper.type $(PAPER_SIZE) \
 --stringparam body.font.family "$(FO_BODY_FONT_FAMILY)" \
 --stringparam title.font.family "$(FO_TITLE_FONT_FAMILY)" \
 --stringparam insert.link.page.number yes \
 --stringparam insert.xref.page.number yes \
 --stringparam graphic.default.extension svg \
 --stringparam generate.toc "$(FO_TOC)" \
 --param use.extensions 1 \
 --param tablecolumns.extension 0 \
 --stringparam admon.graphics.path $(abs_srcdir)/images/ \
 --stringparam admon.graphics.extension .svg
if PROFILING
XSLTPROC_FO_OPTIONS += $(XSLTPROC_PROFILING_OPTIONS)
endif
if USE_FOP
XSLTPROC_FO_OPTIONS += --param fop1.extensions 1
endif

# Saxon parameters
SAXON_PARAMS = admon.graphics=1 \
  l10n.gentext.default.language='$(DEFAULT_LANGUAGE)'
if DRAFT_MODE
SAXON_PARAMS += draft.mode='yes'
endif
if COMMENTS
SAXON_PARAMS += show.comments=1
else
SAXON_PARAMS += show.comments=0
endif
if SYNTAX_HIGHLIGHTING
SAXON_PARAMS += highlight.source=1
endif
if SECTION_NUMBERS
SAXON_PARAMS += section.autolabel=1 \
 section.autolabel.max.depth=$(SECTION_NUMBER_DEPTH) \
 section.label.includes.component.label=1
endif

SAXON_HTML_PARAMS = $(SAXON_PARAMS) \
 use.id.as.filename=1 \
 generate.index=0 \
 admon.graphics.path='images/' \
 admon.graphics.extension='.png' \
 ulink.target='$(ULINK_TARGET)' \
 html.stylesheet='$(CSS)' \
 graphic.default.extension='png'

SAXON_FO_PARAMS =  $(SAXON_PARAMS) \
 paper.type='$(PAPER_SIZE)' \
 body.font.family='$(FO_BODY_FONT_FAMILY)' \
 title.font.family='$(FO_TITLE_FONT_FAMILY)' \
 insert.link.page.number='yes' \
 insert.xref.page.number='yes' \
 graphic.default.extension='svg' \
 generate.toc='$(FO_TOC)'\
 use.extensions=1 \
 tablecolumns.extension=0 \
 admon.graphics.path='$(abs_srcdir)/images/' \
 admon.graphics.extension='.svg'
if USE_FOP
SAXON_FO_PARAMS += fop1.extensions=1
endif

# AsciiDoc options
ASCIIDOC_OPTIONS = --backend=docbook
if FORCE_ASCIIDOC_DOCTYPE
ASCIIDOC_OPTIONS += --doctype=$(ASCIIDOC_DOCTYPE)
endif
if COMMENTS
ASCIIDOC_OPTIONS += --attribute=showcomments
endif
if ENABLE_ASCIIDOC_DOCINFO
ASCIIDOC_OPTIONS += --attribute=docinfo
endif
if ENABLE_ASCIIDOC_BUILDDATE
ASCIIDOC_OPTIONS += --attribute=docdate=`date +%x`
endif

# dblatex options
DBLATEX_OPTIONS = --backend=$(DBLATEX_BACKEND)
if DRAFT_MODE
DBLATEX_OPTIONS += -P draft.mode='yes'
endif
if COMMENTS
DBLATEX_OPTIONS += -P show.comments=1
else
DBLATEX_OPTIONS += -P show.comments=0
endif
if SECTION_NUMBERS
DBLATEX_OPTIONS += -P doc.section.depth=$(SECTION_NUMBER_DEPTH)
endif

# docbook2odf options
DOCBOOK2ODF_OPTIONS = --force

#####################################################################
# Targets for individual document types
#####################################################################

# XML from asciidoc
if ASCIIDOC_SUPPORT
if ENABLE_ASCIIDOC_DOCINFO
%.xml: %.$(ASCIIDOC_EXTENSION) %-docinfo.xml
else
%.xml: %.$(ASCIIDOC_EXTENSION)
endif
	$(ASCIIDOC) --out-file=$@ \
	$(ASCIIDOC_OPTIONS) $<
endif

# HTML (from XML)
if RENDER_HTML
%.html: %.xml
if USE_XSLTPROC
	$(XSLTPROC) \
	$(XSLTPROC_HTML_OPTIONS) \
	--stringparam root.filename $* \
	--output $@ \
	$(HTML_STYLESHEET) $<
endif
if USE_SAXON
	$(SAXON) \
	-o $@ \
	$< $(HTML_STYLESHEET) \
	root.filename='$*' \
	$(SAXON_HTML_PARAMS)
endif
endif

# FO (from XML)
if XSLT
if USE_FO_TITLEPAGE
%.fo: %.xml stylesheets/fo/titlepage.xsl
else
%.fo: %.xml
endif
if USE_XSLTPROC
	$(XSLTPROC) -o $@ \
	$(XSLTPROC_FO_OPTIONS) \
	$(FO_STYLESHEET) $<
endif
if USE_SAXON
	$(SAXON) \
	-o $@ \
	$< $(FO_STYLESHEET) \
	$(SAXON_FO_PARAMS)
endif
endif

# OpenDocument Text (from XML)
if RENDER_ODT
if USE_ODF_TEMPLATE
%.odt: %.odt-tmp
	$(UNOCONV) -f odt -t '$(ODF_TEMPLATE)' $<
%.odt-tmp: %.xml
	$(DOCBOOK2ODF) $(DOCBOOK2ODF_OPTIONS) $< --output-file $@
else
%.odt: %.xml
	$(DOCBOOK2ODF) $(DOCBOOK2ODF_OPTIONS) $< --output-file $@
endif
endif

# Microsoft Word compatible (from ODT)
if RENDER_DOC
%.doc: %.odt
	$(UNOCONV) -f doc $<
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
	$(DBLATEX) $(DBLATEX_OPTIONS) --pdf --output=$@ $<
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
	$(DBLATEX) $(DBLATEX_OPTIONS) --ps --output=$@ $<
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
if USE_XSLTPROC
	$(XSLTPROC) -o $@ \
	$(TITLEPAGE_STYLESHEET) $<
endif
if USE_SAXON
	$(SAXON) -o $@ \
	$< $(TITLEPAGE_STYLESHEET)
endif
endif

# A timestamp file. Holds the date at the time of the invocation
builddate:
	env LC_ALL=C date +"%B %d, %Y" > $@	

# An empty docinfo file. Created if we have docinfo support enabled,
# and no -docinfo.xml file is found
if ENABLE_ASCIIDOC_DOCINFO
%-docinfo.xml:
	echo '<!-- Empty AsciiDoc docinfo file -->' > $@
endif
