# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-texlive/texlive-langarabic/texlive-langarabic-2013.ebuild,v 1.1 2013/06/28 16:19:08 aballier Exp $

EAPI="5"

TEXLIVE_MODULE_CONTENTS="amiri arabi arabtex bidi ghab hyphen-arabic hyphen-farsi imsproc lshort-persian persian-bib persian-modern tram collection-langarabic
"
TEXLIVE_MODULE_DOC_CONTENTS="amiri.doc arabi.doc arabtex.doc bidi.doc ghab.doc imsproc.doc lshort-persian.doc persian-bib.doc persian-modern.doc tram.doc "
TEXLIVE_MODULE_SRC_CONTENTS="bidi.source persian-modern.source "
inherit  texlive-module
DESCRIPTION="TeXLive Arabic"

LICENSE=" GPL-2 LPPL-1.3 OFL public-domain "
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE=""
DEPEND=">=dev-texlive/texlive-basic-2013
!dev-texlive/texlive-langarab
!<dev-texlive/texlive-xetex-2010
!<dev-texlive/texlive-publishers-2013
!dev-texlive/texlive-documentation-arabic
!<dev-texlive/texlive-latexextra-2013
"
RDEPEND="${DEPEND} "
