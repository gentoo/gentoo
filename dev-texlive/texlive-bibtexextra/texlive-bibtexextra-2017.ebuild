# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

TEXLIVE_MODULE_CONTENTS="aichej ajl amsrefs apacite apalike2 archaeologie beebe besjournals bestpapers bibarts biber bibexport bibhtml  biblatex-abnt biblatex-anonymous biblatex-apa biblatex-archaeology biblatex-arthistory-bonn biblatex-bookinarticle biblatex-bookinother biblatex-bwl biblatex-caspervector biblatex-chem biblatex-chicago biblatex-claves biblatex-dw biblatex-fiwi biblatex-gb7714-2015 biblatex-gost biblatex-historian biblatex-ieee biblatex-ijsra biblatex-iso690 biblatex-juradiss biblatex-lni biblatex-luh-ipw biblatex-manuscripts-philology biblatex-mla biblatex-morenames biblatex-multiple-dm biblatex-musuos biblatex-nature biblatex-nejm biblatex-nottsclassic biblatex-opcit-booktitle biblatex-oxref biblatex-philosophy biblatex-phys biblatex-publist biblatex-realauthor biblatex-sbl biblatex-science biblatex-shortfields biblatex-source-division biblatex-subseries biblatex-swiss-legal biblatex-trad biblatex-true-citepages-omit biblist bibtexperllibs bibtopic bibtopicprefix bibunits biolett-bst bookdb breakcites cell chbibref chicago chicago-annote chembst chscite citeall collref compactbib crossrefware custom-bib din1505 dk-bib doipubmed ecobiblatex economic fbs figbib footbib francais-bst geschichtsfrkl harvard harvmac historische-zeitschrift ietfbibs ijqc inlinebib iopart-num jneurosci jurabib ksfh_nat ltb2bib listbib logreq margbib multibib multibibliography munich nar nmbib notes2bib notex-bst oscola perception pnas2009 rsc showtags sort-by-letters splitbib turabian-formatting uni-wtal-ger uni-wtal-lin urlbst usebib vak xcite collection-bibtexextra
"
TEXLIVE_MODULE_DOC_CONTENTS="amsrefs.doc apacite.doc archaeologie.doc besjournals.doc bestpapers.doc bibarts.doc biber.doc bibexport.doc bibhtml.doc biblatex-abnt.doc biblatex-anonymous.doc biblatex-apa.doc biblatex-archaeology.doc biblatex-arthistory-bonn.doc biblatex-bookinarticle.doc biblatex-bookinother.doc biblatex-bwl.doc biblatex-caspervector.doc biblatex-chem.doc biblatex-chicago.doc biblatex-claves.doc biblatex-dw.doc biblatex-fiwi.doc biblatex-gb7714-2015.doc biblatex-gost.doc biblatex-historian.doc biblatex-ieee.doc biblatex-ijsra.doc biblatex-iso690.doc biblatex-juradiss.doc biblatex-lni.doc biblatex-luh-ipw.doc biblatex-manuscripts-philology.doc biblatex-mla.doc biblatex-morenames.doc biblatex-multiple-dm.doc biblatex-musuos.doc biblatex-nature.doc biblatex-nejm.doc biblatex-nottsclassic.doc biblatex-opcit-booktitle.doc biblatex-oxref.doc biblatex-philosophy.doc biblatex-phys.doc biblatex-publist.doc biblatex-realauthor.doc biblatex-sbl.doc biblatex-science.doc biblatex-shortfields.doc biblatex-source-division.doc biblatex-subseries.doc biblatex-swiss-legal.doc biblatex-trad.doc biblatex-true-citepages-omit.doc biblist.doc bibtexperllibs.doc bibtopic.doc bibtopicprefix.doc bibunits.doc biolett-bst.doc bookdb.doc breakcites.doc cell.doc chbibref.doc chicago-annote.doc chembst.doc chscite.doc citeall.doc collref.doc crossrefware.doc custom-bib.doc din1505.doc dk-bib.doc doipubmed.doc ecobiblatex.doc economic.doc figbib.doc footbib.doc francais-bst.doc geschichtsfrkl.doc harvard.doc harvmac.doc historische-zeitschrift.doc ietfbibs.doc ijqc.doc inlinebib.doc iopart-num.doc jneurosci.doc jurabib.doc ltb2bib.doc listbib.doc logreq.doc margbib.doc multibib.doc multibibliography.doc munich.doc nmbib.doc notes2bib.doc oscola.doc perception.doc rsc.doc showtags.doc sort-by-letters.doc splitbib.doc turabian-formatting.doc uni-wtal-ger.doc uni-wtal-lin.doc urlbst.doc usebib.doc vak.doc xcite.doc "
TEXLIVE_MODULE_SRC_CONTENTS="amsrefs.source apacite.source bibarts.source biber.source bibexport.source biblatex-archaeology.source biblatex-gb7714-2015.source biblatex-oxref.source biblatex-philosophy.source bibtexperllibs.source bibtopic.source bibtopicprefix.source bibunits.source chembst.source chscite.source collref.source custom-bib.source dk-bib.source doipubmed.source footbib.source geschichtsfrkl.source harvard.source jurabib.source ltb2bib.source listbib.source margbib.source multibib.source multibibliography.source nmbib.source notes2bib.source rsc.source splitbib.source urlbst.source usebib.source xcite.source "
inherit  texlive-module
DESCRIPTION="TeXLive BibTeX additional styles"

LICENSE=" Artistic GPL-1 GPL-2 GPL-3 LPPL-1.2 LPPL-1.3 LPPL-1.3c public-domain TeX TeX-other-free "
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~arm64 ~hppa ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE=""
DEPEND=">=dev-texlive/texlive-latex-2017
!=dev-texlive/texlive-latexextra-2007*
!<dev-texlive/texlive-latex-2009
!<dev-texlive/texlive-publishers-2014
"
RDEPEND="${DEPEND} "
TEXLIVE_MODULE_BINSCRIPTS="
	texmf-dist/scripts/bibexport/bibexport.sh
	texmf-dist/scripts/urlbst/urlbst
	texmf-dist/scripts/listbib/listbib
	texmf-dist/scripts/multibibliography/multibibliography.pl
	texmf-dist/scripts/crossrefware/ltx2crossrefxml.pl
	texmf-dist/scripts/crossrefware/bibzbladd.pl
	texmf-dist/scripts/crossrefware/bibdoiadd.pl
"
