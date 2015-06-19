# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-misc/fortune-mod-flashrider/fortune-mod-flashrider-0.25.ebuild,v 1.2 2010/11/28 01:59:18 mr_bones_ Exp $

EAPI=2

DESCRIPTION="Quotes from Prolinux articles and comments"
HOMEPAGE="http://www.pro-linux.de/news/2009/14520.html"
SRC_URI="http://www.pro-linux.de/files/fortunes-prolinux-${PV}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 x86"
IUSE=""

DEPEND="games-misc/fortune-mod"

S=${WORKDIR}/${PN/-mod-flashrider/s-prolinux}

src_compile() {
	./mkdat cookies
}

src_install() {
	insinto /usr/share/fortune
	doins prolinux prolinux.dat || die
	dodoc AUTHORS ChangeLog README
}
