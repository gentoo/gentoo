# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit vdr-plugin-2

DESCRIPTION="VDR Plugin: attach some buttons with diodes to the serial port"
HOMEPAGE="http://www.lf-klueber.de/vdr.htm"
SRC_URI="http://www.lf-klueber.de/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="
	media-video/vdr
"

RDEPEND="
	${DEPEND}
	acct-user/vdr[serial]
"

src_prepare() {
	vdr-plugin-2_src_prepare

	sed -i serial.c -e "s:RegisterI18n://RegisterI18n:"

	cd "${S}"/tools
	emake clean
}
