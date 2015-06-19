# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-kernel/raspberrypi-image/raspberrypi-image-3.19.3_pre-r20150327.ebuild,v 1.1 2015/04/01 14:34:52 xmw Exp $

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
