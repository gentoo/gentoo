# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-tex/ivritex/ivritex-1.1.2.ebuild,v 1.16 2008/09/05 06:55:40 opfer Exp $

inherit latex-package

IUSE=""

DESCRIPTION="Hebrew support for TeX"
HOMEPAGE="http://ivritex.sourceforge.net/"
SRC_URI="mirror://sourceforge/ivritex/${P}.tar.gz"
RESTRICT="mirror"

LICENSE="LPPL-1.2"

SLOT="0"
DEPEND=""
KEYWORDS="alpha amd64 hppa ia64 ppc ppc64 sparc x86"

src_install () {

	make TEX_ROOT="${D}"/usr/share/texmf install || die

}
