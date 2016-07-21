# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

TEXLIVE_MODULE_CONTENTS="aichej amsrefs apacite apalike2 beebe bibarts biber bibexport bibhtml  biblatex-apa biblatex-bwl biblatex-caspervector biblatex-chem biblatex-chicago biblatex-dw biblatex-fiwi biblatex-gost biblatex-historian biblatex-ieee biblatex-juradiss biblatex-luh-ipw biblatex-mla biblatex-musuos biblatex-nature biblatex-nejm biblatex-philosophy biblatex-phys biblatex-publist biblatex-science biblatex-swiss-legal biblatex-trad biblist bibtopic bibtopicprefix bibunits breakcites cell chbibref chicago chicago-annote chembst chscite collref compactbib custom-bib din1505 dk-bib doipubmed fbs figbib footbib francais-bst geschichtsfrkl harvard harvmac historische-zeitschrift ijqc inlinebib iopart-num jneurosci jurabib ksfh_nat listbib logreq margbib multibib multibibliography munich notes2bib oscola perception pnas2009 rsc showtags sort-by-letters splitbib uni-wtal-ger uni-wtal-lin urlbst usebib vak xcite collection-bibtexextra
"
TEXLIVE_MODULE_DOC_CONTENTS="amsrefs.doc apacite.doc bibarts.doc biber.doc bibexport.doc bibhtml.doc biblatex-apa.doc biblatex-bwl.doc biblatex-caspervector.doc biblatex-chem.doc biblatex-chicago.doc biblatex-dw.doc biblatex-fiwi.doc biblatex-gost.doc biblatex-historian.doc biblatex-ieee.doc biblatex-juradiss.doc biblatex-luh-ipw.doc biblatex-mla.doc biblatex-musuos.doc biblatex-nature.doc biblatex-nejm.doc biblatex-philosophy.doc biblatex-phys.doc biblatex-publist.doc biblatex-science.doc biblatex-swiss-legal.doc biblatex-trad.doc biblist.doc bibtopic.doc bibtopicprefix.doc bibunits.doc breakcites.doc cell.doc chbibref.doc chicago-annote.doc chembst.doc chscite.doc collref.doc custom-bib.doc din1505.doc dk-bib.doc doipubmed.doc figbib.doc footbib.doc francais-bst.doc geschichtsfrkl.doc harvard.doc harvmac.doc historische-zeitschrift.doc ijqc.doc inlinebib.doc iopart-num.doc jneurosci.doc jurabib.doc listbib.doc logreq.doc margbib.doc multibib.doc multibibliography.doc munich.doc notes2bib.doc oscola.doc perception.doc rsc.doc showtags.doc sort-by-letters.doc splitbib.doc uni-wtal-ger.doc uni-wtal-lin.doc urlbst.doc usebib.doc vak.doc xcite.doc "
TEXLIVE_MODULE_SRC_CONTENTS="amsrefs.source apacite.source bibarts.source biber.source bibexport.source biblatex-philosophy.source bibtopic.source bibtopicprefix.source bibunits.source chembst.source chscite.source collref.source custom-bib.source dk-bib.source doipubmed.source footbib.source geschichtsfrkl.source harvard.source jurabib.source listbib.source margbib.source multibib.source multibibliography.source notes2bib.source rsc.source splitbib.source urlbst.source usebib.source xcite.source "
inherit  texlive-module
DESCRIPTION="TeXLive BibTeX additional styles"

LICENSE=" Artistic GPL-1 GPL-2 LPPL-1.2 LPPL-1.3 public-domain TeX-other-free "
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE=""
DEPEND=">=dev-texlive/texlive-latex-2013
!=dev-texlive/texlive-latexextra-2007*
!<dev-texlive/texlive-latex-2009
"
RDEPEND="${DEPEND} "
TEXLIVE_MODULE_BINSCRIPTS="
	texmf-dist/scripts/bibexport/bibexport.sh
	texmf-dist/scripts/urlbst/urlbst
	texmf-dist/scripts/listbib/listbib
	texmf-dist/scripts/multibibliography/multibibliography.pl
"
