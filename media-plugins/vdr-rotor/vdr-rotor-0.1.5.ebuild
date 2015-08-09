# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="4"

inherit vdr-plugin-2

DESCRIPTION="VDR Plugin: Add support for dishes with rotation control engine"
HOMEPAGE="http://home.vrweb.de/~bergwinkl.thomas/"
SRC_URI="http://home.vrweb.de/~bergwinkl.thomas/downro/${P}.tgz"
LICENSE="GPL-2"

KEYWORDS="x86 amd64"
SLOT="0"
IUSE=""

DEPEND=">=media-video/vdr-1.6.0[rotor]"
RDEPEND="${DEPEND}"

pkg_setup() {
	vdr-plugin-2_pkg_setup

	elog "Checking for patched vdr"
	if ! grep -q SendDiseqcCmd /usr/include/vdr/device.h; then
		ewarn "You need to emerge vdr with use-flag rotor set!"
		die "Unpatched vdr detected!"
	fi
}

src_prepare() {
	vdr-plugin-2_src_prepare

	if has_version ">=media-video/vdr-1.7.13"; then
		epatch "${FILESDIR}/${P}_vdr-1.7.13.diff"
	fi
}
