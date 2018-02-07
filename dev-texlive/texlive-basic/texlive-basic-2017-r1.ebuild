# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

TEXLIVE_MODULE_CONTENTS="amsfonts bibtex cm enctex etex etex-pkg graphics-def hyph-utf8 ifluatex ifxetex knuth-lib knuth-local lua-alt-getopt luatex makeindex metafont mflogo mfware pdftex plain tex tex-ini-files texlive-common texlive-docindex texlive-en texlive-msg-translations texlive-scripts unicode-data updmap-map collection-basic
"
TEXLIVE_MODULE_DOC_CONTENTS="amsfonts.doc bibtex.doc cm.doc enctex.doc etex.doc etex-pkg.doc graphics-def.doc hyph-utf8.doc ifluatex.doc ifxetex.doc lua-alt-getopt.doc luatex.doc makeindex.doc metafont.doc mflogo.doc mfware.doc pdftex.doc tex.doc tex-ini-files.doc texlive-common.doc texlive-docindex.doc texlive-en.doc texlive-scripts.doc unicode-data.doc "
TEXLIVE_MODULE_SRC_CONTENTS="amsfonts.source hyph-utf8.source ifluatex.source ifxetex.source mflogo.source "
TEXLIVE_MODULE_OPTIONAL_ENGINE="luajittex"
inherit  texlive-module
DESCRIPTION="TeXLive Essential programs and files"

LICENSE=" GPL-1 GPL-2 LPPL-1.3 OFL public-domain TeX TeX-other-free "
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE=""
DEPEND="!<dev-texlive/texlive-latex-2009
!<dev-texlive/texlive-latexrecommended-2009
!dev-texlive/texlive-documentation-base
!<app-text/dvipsk-5.996_p20160523
>=app-text/texlive-core-2015[luajittex?]
"
RDEPEND="${DEPEND} "
PATCHES=( "${FILESDIR}/texmfcnflua2017.patch" )
TEXLIVE_MODULE_BINSCRIPTS="texmf-dist/scripts/simpdftex/simpdftex texmf-dist/scripts/texlive/rungs.tlu"
DEPEND="${DEPEND}
!!<dev-texlive/texlive-basic-2016
!!<dev-texlive/texlive-langafrican-2016
!!<dev-texlive/texlive-langarabic-2016
!!<dev-texlive/texlive-langarmenian-2016
!!<dev-texlive/texlive-langchinese-2016
!!<dev-texlive/texlive-langcjk-2016
!!<dev-texlive/texlive-langcroatian-2016
!!<dev-texlive/texlive-langcyrillic-2016
!!<dev-texlive/texlive-langczechslovak-2016
!!<dev-texlive/texlive-langdanish-2016
!!<dev-texlive/texlive-langdutch-2016
!!<dev-texlive/texlive-langenglish-2016
!!<dev-texlive/texlive-langeuropean-2016
!!<dev-texlive/texlive-langfinnish-2016
!!<dev-texlive/texlive-langfrench-2016
!!<dev-texlive/texlive-langgerman-2016
!!<dev-texlive/texlive-langgreek-2016
!!<dev-texlive/texlive-langhebrew-2016
!!<dev-texlive/texlive-langhungarian-2016
!!<dev-texlive/texlive-langindic-2016
!!<dev-texlive/texlive-langitalian-2016
!!<dev-texlive/texlive-langjapanese-2016
!!<dev-texlive/texlive-langkorean-2016
!!<dev-texlive/texlive-langlatin-2016
!!<dev-texlive/texlive-langlatvian-2016
!!<dev-texlive/texlive-langlithuanian-2016
!!<dev-texlive/texlive-langmongolian-2016
!!<dev-texlive/texlive-langnorwegian-2016
!!<dev-texlive/texlive-langother-2016
!!<dev-texlive/texlive-langpolish-2016
!!<dev-texlive/texlive-langportuguese-2016
!!<dev-texlive/texlive-langspanish-2016
!!<dev-texlive/texlive-langswedish-2016
!!<dev-texlive/texlive-langtibetan-2016
!!<dev-texlive/texlive-langturkmen-2016
!!<dev-texlive/texlive-langvietnamese-2016
"
RDEPEND="${RDEPEND}
!<dev-texlive/texlive-latex-2016
"
