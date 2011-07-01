# makedoc: A document processing toolchain built on GNU Autotools

makedoc turns [AsciiDoc](http://www.methods.co.nz/asciidoc/) or
[DocBook](http://www.docbook.org) documents into a variety of output
formats, including:

* HTML
* PDF and PostScript
* Open Document Format (used by OpenOffice.org Writer)
* Microsoft(R) Word(tm)

In addition, makedoc transforms

* MathML into Scalable Vector Graphics (SVG)
* SVG into Portable Network Graphics (PNG)

## Processing documents with makedoc

In its simplest form, check out the makedoc tree from GitHub and drop
an AsciiDoc (`.txt`) or DocBook source document (`.xml`) into the work
directory.

Say your AsciiDoc document is named `foobar.txt`. Then, run

```bash
./autogen.sh
./configure
cd work
make foobar.pdf foobar.html
```

Then, makedoc will build a PDF and HTML representation of foobar.txt.

## Using makedoc from your own project

If you are integrating your own documentation project with makedoc,
follow these steps:

* From the root of your documentation tree, create symlinks to
  `autogen.sh`, `configure.ac.stub`, and `Makefile.am`, located in the root
  of the makedoc checkout.
* From any of you subdirectories where you keep documentation sources,
  create symlinks to `work/Makefile.am`.
* Run `autogen.sh` and `./configure` from the root of _your_ checkout.
* Change into your documentation directories and run `make
  <sourcefile>.<outputformat>`, like `make foo.pdf` or `make bar.html`.

## Configuring makedoc

Makedoc's behavior can be heavily customized to your needs. Run
./configure --help for supported options. Makedoc allows you to

* select your PDF renderer (fop, db2latex, or xmlroff)
* customize PDF page sizes and fonts
* select your XSLT processor (xsltproc or saxon)
* select your SVG rasterizer (rsvg or inkscape)
* link custom CSS style sheets and DocBook titlepage templates
* customize section numbering and labeling
* select the document type (article, book, or manpage)
* select templates for ODF output
