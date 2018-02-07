# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

TEXLIVE_MODULE_CONTENTS="amsldoc-vn aramaic-serto hyphen-armenian babel-azerbaijani babel-esperanto babel-georgian babel-hebrew babel-indonesian babel-interlingua babel-malay babel-sorbian babel-thai babel-vietnamese bangtex bengali burmese cjhebrew ctib ebong ethiop ethiop-t1 fc fonts-tlwg hyphen-afrikaans hyphen-coptic hyphen-esperanto hyphen-ethiopic hyphen-georgian hyphen-indic hyphen-indonesian hyphen-interlingua hyphen-sanskrit hyphen-thai hyphen-turkmen latexbangla lshort-thai lshort-vietnamese ntheorem-vn padauk sanskrit sanskrit-t1 thaienum velthuis vntex wnri wnri-latex xetex-devanagari collection-langother
"
TEXLIVE_MODULE_DOC_CONTENTS="amsldoc-vn.doc aramaic-serto.doc babel-azerbaijani.doc babel-esperanto.doc babel-georgian.doc babel-hebrew.doc babel-indonesian.doc babel-interlingua.doc babel-malay.doc babel-sorbian.doc babel-thai.doc babel-vietnamese.doc bangtex.doc bengali.doc burmese.doc cjhebrew.doc ctib.doc ebong.doc ethiop.doc ethiop-t1.doc fc.doc fonts-tlwg.doc hyphen-sanskrit.doc latexbangla.doc lshort-thai.doc lshort-vietnamese.doc ntheorem-vn.doc padauk.doc sanskrit.doc sanskrit-t1.doc thaienum.doc velthuis.doc vntex.doc wnri.doc wnri-latex.doc xetex-devanagari.doc "
TEXLIVE_MODULE_SRC_CONTENTS="hyphen-armenian.source babel-azerbaijani.source babel-esperanto.source babel-hebrew.source babel-indonesian.source babel-interlingua.source babel-malay.source babel-sorbian.source babel-thai.source babel-vietnamese.source bengali.source burmese.source ctib.source ethiop.source fonts-tlwg.source hyphen-ethiopic.source hyphen-turkmen.source sanskrit.source vntex.source wnri-latex.source "
inherit  texlive-module
DESCRIPTION="TeXLive Other languages"

LICENSE=" GPL-1 GPL-2 LGPL-2 LPPL-1.3 OFL public-domain TeX-other-free "
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE=""
DEPEND=">=dev-texlive/texlive-basic-2017
!<dev-texlive/texlive-basic-2009
!dev-texlive/texlive-documentation-vietnamese
!dev-texlive/texlive-langvietnamese
!<dev-texlive/texlive-langcjk-2013
!dev-texlive/texlive-langhebrew
!dev-texlive/texlive-documentation-thai
!dev-texlive/texlive-langturkmen
!dev-texlive/texlive-langtibetan
!<dev-texlive/texlive-basic-2016
!<dev-texlive/texlive-langafrican-2017
!<dev-texlive/texlive-langindic-2017
!<dev-texlive/texlive-langeuropean-2017
"
RDEPEND="${DEPEND} "
TEXLIVE_MODULE_BINSCRIPTS="texmf-dist/scripts/ebong/ebong.py"
