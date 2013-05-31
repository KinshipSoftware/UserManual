# A Makefile to generate the HTML and PDF docs: targets 'pdf' and 'html'
# By default this does not upload: svn and sitecopy commands are replaced with "true"

# Paths:
CORPUSTOOLDIR=../../../corpustools
PDFDIR=~/PDF
# HTMLDIR must end with a "/"!
HTMLDIR=html/

XSLTPROC=xsltproc
XSL=$(CORPUSTOOLDIR)/Docbook-xsl/customization/mydocbook2html.xsl
XSLFO=$(CORPUSTOOLDIR)/Docbook-xsl/customization/mydocbook2fo.xsl
FOP=fop
SITECOPY=true
SVN=true
CP=true
CHMOD=true
DOWNSCALE=$(CORPUSTOOLDIR)/image_downscale.sh
# Setting "SHELL" is recommended in some make documentation:
SHELL=/bin/sh

all:	html pdf

html: $(HTMLDIR)index.html

pdf: $(PDFDIR)/manual-kinoath.pdf

clean:
# using "rm -f" so make does not interrupt if the pdf does not exist
	rm -f $(PDFDIR)/manual-kinoath.pdf
	rm -rf $(HTMLDIR)

$(HTMLDIR)index.html: kinoath.xml
	echo; echo "Kinoath manual: Creating HTML version:";
	$(DOWNSCALE) images ../$(HTMLDIR)images
	$(XSLTPROC) -o $(HTMLDIR) $(XSL) kinoath.xml
	echo "Uploading HTML version:";
	$(CP) -r $(HTMLDIR)* /data/extweb2/htdocs/world/corpus/html/kinoath
	$(CHMOD) a+r /data/extweb2/htdocs/world/corpus/html/kinoath/*.html
	$(CHMOD) a+r /data/extweb2/htdocs/world/corpus/html/kinoath/images/*.*

$(PDFDIR)/manual-kinoath.pdf:	kinoath.xml
	echo; echo "Kinoath manual: Creating PDF version:";
	$(XSLTPROC) $(XSLFO) kinoath.xml > kinoath.fo
	$(FOP) -fo kinoath.fo -pdf $(PDFDIR)/manual-kinoath.pdf
	rm kinoath.fo
	echo "Uploading PDF version:";
	$(SVN) commit -m 'auto commit by Makefile' $(PDFDIR)/manual-kinoath.pdf
