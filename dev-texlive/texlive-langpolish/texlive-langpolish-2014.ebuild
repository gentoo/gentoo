# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-texlive/texlive-langpolish/texlive-langpolish-2014.ebuild,v 1.2 2015/07/12 15:46:28 ago Exp $

EAPI="5"

TEXLIVE_MODULE_CONTENTS="babel-polish cc-pl gustlib gustprog hyphen-polish lshort-polish mex mwcls pl polski przechlewski-book qpxqtx tap tex-virtual-academy-pl texlive-pl utf8mex collection-langpolish
"
TEXLIVE_MODULE_DOC_CONTENTS="babel-polish.doc cc-pl.doc gustlib.doc gustprog.doc lshort-polish.doc mex.doc mwcls.doc pl.doc polski.doc przechlewski-book.doc qpxqtx.doc tap.doc tex-virtual-academy-pl.doc texlive-pl.doc utf8mex.doc "
TEXLIVE_MODULE_SRC_CONTENTS="babel-polish.source mex.source mwcls.source polski.source "
inherit  texlive-module
DESCRIPTION="TeXLive Polish"

LICENSE=" GPL-2 LPPL-1.2 LPPL-1.3 public-domain TeX-other-free "
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~hppa ~mips ~ppc ~ppc64 ~s390 ~sh ~x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE=""
DEPEND=">=dev-texlive/texlive-latex-2014
>=dev-texlive/texlive-basic-2014
!dev-texlive/texlive-documentation-polish
"
RDEPEND="${DEPEND} "
