# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit vdr-plugin-2

DESCRIPTION="VDR Plugin: output device for the 'Full Featured' SD DVB Card"
HOMEPAGE="http://www.tvdr.de/"
SRC_URI="http://ftp.tvdr.de/Plugins/${P}.tgz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 x86"

DEPEND="media-video/vdr"
RDEPEND="${DEPEND}"

src_install() {
	default

	doheader "${S}"/dvbsdffdevice.h
}
