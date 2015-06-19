# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-texlive/texlive-langarabic/texlive-langarabic-2012.ebuild,v 1.12 2013/04/25 21:27:41 ago Exp $

EAPI="4"

TEXLIVE_MODULE_CONTENTS="amiri arabi arabtex bidi hyphen-arabic hyphen-farsi persian-bib persian-modern collection-langarabic
"
TEXLIVE_MODULE_DOC_CONTENTS="amiri.doc arabi.doc arabtex.doc bidi.doc persian-bib.doc persian-modern.doc "
TEXLIVE_MODULE_SRC_CONTENTS="bidi.source persian-modern.source "
inherit  texlive-module
DESCRIPTION="TeXLive Arabic"

LICENSE="GPL-2 LPPL-1.3 OFL "
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 s390 sh sparc x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE=""
DEPEND=">=dev-texlive/texlive-basic-2012
!dev-texlive/texlive-langarab
!<dev-texlive/texlive-xetex-2010
"
RDEPEND="${DEPEND} "
