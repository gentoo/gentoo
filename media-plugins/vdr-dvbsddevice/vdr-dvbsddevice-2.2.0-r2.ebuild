# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit vdr-plugin-2

DESCRIPTION="VDR Plugin: output device for the 'Full Featured' SD DVB Card"
HOMEPAGE="http://www.tvdr.de/"
SRC_URI="http://ftp.tvdr.de/Plugins/${P}.tgz"

KEYWORDS="amd64 x86"
SLOT="0"
LICENSE="GPL-2+"

DEPEND=">=media-video/vdr-2.2.0"
RDEPEND="${DEPEND}"

src_install() {
	default

	doheader "${S}"/dvbsdffdevice.h
}
