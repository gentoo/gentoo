# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/filepp/filepp-1.8.0.ebuild,v 1.3 2014/08/10 21:26:59 slyfox Exp $

EAPI=3

DESCRIPTION="a generic file preprocessor with a CPP-like syntax"
HOMEPAGE="http://www.cabaret.demon.co.uk/filepp"
SRC_URI="http://www.cabaret.demon.co.uk/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~mips ~ppc ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos"
IUSE=""

moduledir="${EPREFIX}/usr/share/${P}/modules"

src_configure() {
	econf --with-moduledir=${moduledir}
}

src_install() {
	einstall moduledir="${D}"/${moduledir} || die "einstall failed."
	dodoc ChangeLog README
	dohtml *.html
}
