# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

TEXLIVE_MODULE_CONTENTS="amiri arabi arabi-add arabluatex arabtex bidi bidihl dad ghab hyphen-arabic hyphen-farsi imsproc lshort-persian persian-bib simurgh tram xepersian collection-langarabic
"
TEXLIVE_MODULE_DOC_CONTENTS="amiri.doc arabi.doc arabi-add.doc arabluatex.doc arabtex.doc bidi.doc bidihl.doc dad.doc ghab.doc imsproc.doc lshort-persian.doc persian-bib.doc simurgh.doc tram.doc xepersian.doc "
TEXLIVE_MODULE_SRC_CONTENTS="arabluatex.source bidi.source xepersian.source "
inherit  texlive-module
DESCRIPTION="TeXLive Arabic"

LICENSE=" CC-BY-SA-4.0 GPL-2 GPL-3+ LPPL-1.3 LPPL-1.3c OFL public-domain "
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE=""
DEPEND=">=dev-texlive/texlive-basic-2017
!dev-texlive/texlive-langarab
!<dev-texlive/texlive-xetex-2016
!<dev-texlive/texlive-publishers-2013
!dev-texlive/texlive-documentation-arabic
!<dev-texlive/texlive-latexextra-2013
!<dev-texlive/texlive-basic-2016
"
RDEPEND="${DEPEND} "
