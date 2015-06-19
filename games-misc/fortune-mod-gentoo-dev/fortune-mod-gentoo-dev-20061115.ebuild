# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-misc/fortune-mod-gentoo-dev/fortune-mod-gentoo-dev-20061115.ebuild,v 1.2 2010/10/08 03:49:37 leio Exp $

DESCRIPTION="Fortune database of #gentoo-dev quotes"
HOMEPAGE="http://dev.gentoo.org/~avenj"
SRC_URI="http://ircd.oppresses.us/~avenj/files/gentoo-dev-${PV}.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86 ~x86-fbsd"
IUSE=""

RDEPEND="games-misc/fortune-mod"

S=${WORKDIR}

src_compile() {
	mv gentoo-dev-${PV} gentoo-dev || die
	strfile gentoo-dev || die
}

src_install() {
	insinto /usr/share/fortune
	doins gentoo-dev gentoo-dev.dat || die
}
