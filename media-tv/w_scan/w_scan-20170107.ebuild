# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Scan DVB-C/DVB-T/DVB-S channels"
HOMEPAGE="http://wirbel.htpc-forum.de/w_scan/index2.html"
SRC_URI="http://wirbel.htpc-forum.de/w_scan/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="doc examples"

DEPEND="sys-kernel/linux-headers"

PATCHES=( "${FILESDIR}"/${P}-fno-common.patch )

src_install() {
	default

	if use doc; then
		dodoc doc/README.file_formats doc/README_VLC_DVB
	fi

	if use examples; then
		docinto examples
		dodoc doc/rotor.conf
	fi
}
