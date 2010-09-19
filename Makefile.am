# This is the top-level Makefile. When creating a subdirectory for a
# new howto, create a new Makefile in that directory, referring back
# to this one. Like so:
#
# %: force
# 	@$(MAKE) -f ../Makefile $@
# force: ;
#
# That target should go after all other targets you define in your
# lower-level Makefile. Refer the Makefile in the "users-guide"
# subdirectory as an example.

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
if PROFILING
FO_STYLESHEET ?= $(abs_srcdir)/stylesheets/profile-fo.xsl
else
FO_STYLESHEET ?= $(abs_srcdir)/stylesheets/fo.xsl
endif

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
 --param section.autolabel 1 \
 --param section.autolabel.max.depth 2 \
 --param section.label.includes.component.label 1 \
 --stringparam generate.toc "$(FO_TOC)" \
 --param use.extensions 1 \
 --param fop1.extensions 1 \
 --param tablecolumns.extension 0 \
 --param admon.graphics 1 \
 --stringparam admon.graphics.path $(abs_srcdir)/images/ \
 --stringparam admon.graphics.extension .svg
if PROFILING
XSLTPROC_FO_OPTIONS += $(XSLTPROC_PROFILING_OPTIONS)
endif

# XML from asciidoc
if ASCIIDOC_SUPPORT
%.xml: %.asciidoc
	$(ASCIIDOC) --out-file=$@ \
	--backend=docbook --doctype=article $<
endif

# Multiple-page HTML
%.html: %.xml
	$(XSLTPROC) \
	$(XSLTPROC_HTML_OPTIONS) \
	--stringparam root.filename $* \
	$(CHUNKED_HTML_STYLESHEET) $< 

%.fo: %.xml $(abs_srcdir)/stylesheets/fo-titlepage.xsl
	$(XSLTPROC) -o $@ \
	$(XSLTPROC_FO_OPTIONS) \
	$(FO_STYLESHEET) $<

if RENDER_PDF
%.pdf: %.fo
	$(FOP) -c $(abs_srcdir)/$(FOP_CONFIG) $< -pdf $@

%.ps: %.fo
	$(FOP) -c $(abs_srcdir)/$(FOP_CONFIG) $< -ps $@
endif

if RENDER_ODT
%.odt: %.xml
	$(DOCBOOK2ODF) --force $< --output-file $@
endif

# Title page layout (currently only used for FOP-generated PDF)
%-titlepage.xsl: %-titlepage.xml
	$(XSLTPROC) -o $@ \
	--xinclude $(TITLEPAGE_STYLESHEET) $<

# Generated images: SVG from MathML
# (needed for HTML output, and PDF if using FOP)
# The ugly sed hack is because batik (used by FOP) complains about
# 'svg version="1"', while 'svg version="1.0"' is OK.
if RENDER_MML
%.svg: %.mml
	$(MATHMLSVG) --font-size=24 $< 
	$(SED)-i -e 's/<svg version="1"/<svg version="1.0"/' $@
endif

# Generated images: PNG from SVG
# n(eeded for HTML output)
if RENDER_SVG
%.png: %.svg
	$(INKSCAPE) --file=$< --export-dpi=90 --export-area-drawing --export-png=$@

%-small.png: %.svg
	$(INKSCAPE) --file=$< --export-dpi=45 --export-area-drawing --export-png=$@

%-large.png: %.svg
	$(INKSCAPE) --file=$< --export-dpi=180 --export-area-drawing --export-png=$@
endif

builddate:
	env LC_ALL=C date +"%B %d, %Y" > $@	

