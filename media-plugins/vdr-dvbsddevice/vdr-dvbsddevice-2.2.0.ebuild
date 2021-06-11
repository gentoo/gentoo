# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit vdr-plugin-2

DESCRIPTION="VDR Plugin: output device for the 'Full Featured' SD DVB Card"
HOMEPAGE="http://www.tvdr.de/"
SRC_URI="mirror://gentoo/${P}.tar.gz
		https://dev.gentoo.org/~hd_brummy/distfiles/${P}.tar.gz"

KEYWORDS="amd64 x86"
SLOT="0"
LICENSE="GPL-2"
IUSE=""

DEPEND=">=media-video/vdr-2.2.0"
RDEPEND="${DEPEND}"

src_install() {
	vdr-plugin-2_src_install

	doheader "${S}"/dvbsdffdevice.h
}
