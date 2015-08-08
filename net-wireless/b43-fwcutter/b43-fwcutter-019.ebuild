# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit toolchain-funcs

DESCRIPTION="Firmware Tool for Broadcom 43xx based wireless network devices
using the mac80211 wireless stack"
HOMEPAGE="http://bues.ch/b43/fwcutter"
SRC_URI="http://bues.ch/b43/fwcutter/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc ~ppc64 x86"
IUSE=""

src_compile() {
	MAKEOPTS+=" V=1"
	emake CC="$(tc-getCC)"
}

src_install() {
	# Install fwcutter
	dobin ${PN}
	doman ${PN}.1
	dodoc README
}

pkg_postinst() {
	echo
	einfo "Firmware may be downloaded from http://linuxwireless.org."
	einfo "This version of fwcutter works with all b43 driver versions."
	echo
}
