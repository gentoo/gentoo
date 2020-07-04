# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Network scanning plugin for EPSON scanners (nonfree)"

HOMEPAGE="http://download.ebz.epson.net/dsc/search/01/search/?OSC=LX"
# This is distributed as part of the "bundle driver"; since we already have the
# opensource part separately we just install the nonfree part here.

ISCAN_VERSION="2.30.4"

SRC_URI="https://download2.ebz.epson.net/iscan/general/deb/x64/iscan-bundle-${ISCAN_VERSION}.x64.deb.tar.gz"

LICENSE="EPSON-2018"

SLOT="0"

#KEYWORDS="~amd64"
# No keywords since I havent really gotten it to work yet. However, installation
# locations are clearly correct... may be a hardware/network problem on my side.

RESTRICT="bindist mirror strip"

RDEPEND="media-gfx/iscan"
BDEPEND="app-arch/deb2targz"

src_unpack() {
	default
	mv ./iscan-bundle-${ISCAN_VERSION}.x64.deb/plugins/iscan-network-nt_*_amd64.deb ${P}.deb || die
	mkdir ${P} || die
	cd ${P} || die
	unpack ../${P}.deb
	unpack "${S}/data.tar.gz"
}

src_install() {
	exeinto /usr/lib/iscan
	doexe usr/lib/iscan/network

	gunzip usr/share/doc/iscan-network-nt/*.gz
	dodoc usr/share/doc/iscan-network-nt/*
}
