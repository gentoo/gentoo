# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

TEXLIVE_MODULE_CONTENTS="amsfonts bibtex cm colorprofiles ec enctex etex etex-pkg graphics-def hyph-utf8 hyphenex ifplatform iftex knuth-lib knuth-local lua-alt-getopt luahbtex luatex makeindex metafont mflogo mfware modes pdftex plain tex tex-ini-files texlive-common texlive-docindex texlive-en texlive-msg-translations tlshell unicode-data updmap-map collection-basic
"
TEXLIVE_MODULE_DOC_CONTENTS="amsfonts.doc bibtex.doc cm.doc colorprofiles.doc ec.doc enctex.doc etex.doc etex-pkg.doc graphics-def.doc hyph-utf8.doc ifplatform.doc iftex.doc lua-alt-getopt.doc luahbtex.doc luatex.doc makeindex.doc metafont.doc mflogo.doc mfware.doc modes.doc pdftex.doc tex.doc tex-ini-files.doc texlive-common.doc texlive-docindex.doc texlive-en.doc tlshell.doc unicode-data.doc "
TEXLIVE_MODULE_SRC_CONTENTS="amsfonts.source hyph-utf8.source hyphenex.source ifplatform.source mflogo.source "
TEXLIVE_MODULE_OPTIONAL_ENGINE="luajittex"
inherit  texlive-module
DESCRIPTION="TeXLive Essential programs and files"

LICENSE=" GPL-1 GPL-2 LPPL-1.3 LPPL-1.3c MIT OFL public-domain TeX TeX-other-free "
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE=""
DEPEND="!<app-text/dvipsk-5.996_p20160523
>=app-text/texlive-core-2020[luajittex?]
!~dev-texlive/texlive-fontsrecommended-2019
!~dev-texlive/texlive-plaingeneric-2019
!~dev-texlive/texlive-latexextra-2019
"
RDEPEND="${DEPEND} "
TEXLIVE_MODULE_BINSCRIPTS="texmf-dist/scripts/simpdftex/simpdftex"
