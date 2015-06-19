# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-firmware/tt-s2-6400-firmware/tt-s2-6400-firmware-0.5.0.ebuild,v 1.2 2015/01/03 00:25:13 hd_brummy Exp $

EAPI=5

RESTRICT="mirror bindist"

DESCRIPTION="Firmware for the Technotrend S2-6400 DVB Card"
HOMEPAGE="http://www.aregel.de/"
SRC_URI="http://www.aregel.de/file_download/27/dvb-ttpremium-st7109-01_v0_5_0.zip
	http://www.aregel.de/file_download/26/dvb-ttpremium-fpga-01_v1_10.zip
	http://www.aregel.de/file_download/7/dvb-ttpremium-loader-01_v1_03.zip"

LICENSE="all-rights-reserved"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND="app-arch/unzip"
RDEPEND=""

S=${WORKDIR}

src_install() {
	insinto /lib/firmware
	doins dvb-ttpremium-fpga-01.fw dvb-ttpremium-loader-01.fw dvb-ttpremium-st7109-01.fw
}
