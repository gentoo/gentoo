# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

TEXLIVE_MODULE_CONTENTS="babel-polish bredzenie cc-pl gustlib gustprog hyphen-polish lshort-polish mex mwcls pl polski przechlewski-book qpxqtx tap tex-virtual-academy-pl texlive-pl utf8mex collection-langpolish
"
TEXLIVE_MODULE_DOC_CONTENTS="babel-polish.doc bredzenie.doc cc-pl.doc gustlib.doc gustprog.doc lshort-polish.doc mex.doc mwcls.doc pl.doc polski.doc przechlewski-book.doc qpxqtx.doc tap.doc tex-virtual-academy-pl.doc texlive-pl.doc utf8mex.doc "
TEXLIVE_MODULE_SRC_CONTENTS="babel-polish.source mex.source mwcls.source polski.source "
inherit  texlive-module
DESCRIPTION="TeXLive Polish"

LICENSE=" FDL-1.1 GPL-2 LPPL-1.2 LPPL-1.3 LPPL-1.3c public-domain TeX "
SLOT="0"
KEYWORDS="alpha amd64 arm ~arm64 hppa ia64 ~mips ppc ppc64 s390 ~sh sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE=""
DEPEND=">=dev-texlive/texlive-latex-2019
>=dev-texlive/texlive-basic-2019
!<dev-texlive/texlive-basic-2016
"
RDEPEND="${DEPEND} "
