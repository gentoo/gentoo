# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DESCRIPTION="A Java client for the Kiseido Go Server, and a SGF editor"
HOMEPAGE="http://www.gokgs.com/"
SRC_URI="mirror://gentoo/cgoban-unix-${PV}.tar.bz2"

LICENSE="freedist"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=virtual/jre-1.3"

S=${WORKDIR}/cgoban

src_install() {
	dodir /usr/bin
	sed -e "s:INSTALL_DIR:/usr/share/${PN}:" \
		"${FILESDIR}/${PN}" > "${D}/usr/bin/${PN}" || die
	insinto /usr/share/${PN}
	doins cgoban.jar
}
