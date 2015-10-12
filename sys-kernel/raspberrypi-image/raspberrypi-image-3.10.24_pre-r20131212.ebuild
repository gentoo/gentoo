# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

DESCRIPTION="Raspberry PI precompiled kernel and modules"
HOMEPAGE="https://github.com/raspberrypi/firmware"
SRC_URI="https://dev.gentoo.org/~xmw/${PN}/${PF}.tar.xz"

LICENSE="GPL-2"
SLOT="${PVR}"
KEYWORDS="~arm -*"
IUSE=""

S=${WORKDIR}

RESTRICT="binchecks mirror strip"

src_prepare() {
	#hide kernel vectors
	chmod go= boot/System* || die
	# on a filesystem with permissions
	mv boot/System* lib/modules/* || die
	elog "System.map has been moved to $(ls -d lib/modules/*)"
}

src_install() {
	mv -v boot "${D}" || die

	dodir /lib
	mv -v lib/modules "${D}"/lib || die
}
