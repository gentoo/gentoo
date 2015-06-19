# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/filepp/filepp-1.6.0.ebuild,v 1.14 2009/10/12 19:14:43 ssuominen Exp $

DESCRIPTION="Generic file-preprocessor with a CPP-like syntax"
HOMEPAGE="http://www.cabaret.demon.co.uk/filepp/"
SRC_URI="http://www.cabaret.demon.co.uk/filepp/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~mips ppc s390 sparc x86"
IUSE=""

moduledir="/usr/share/${P}/modules"

src_compile() {
	econf --with-moduledir=${moduledir} || die "econf failed"
}

src_install() {
	einstall moduledir="${D}/${moduledir}"
	dodoc ChangeLog README
	dohtml filepp.html
}
