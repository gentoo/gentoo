# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit vdr-plugin-2 linux-info udev

VERSION="2086" # every bump, new version

DESCRIPTION="VDR Plugin: shows information about the current state of VDR on iMON LCD"
HOMEPAGE="http://projects.vdr-developer.org/wiki/plg-imonlcd"
SRC_URI="mirror://vdr-developerorg/${VERSION}/${P}.tgz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="media-libs/freetype"
DEPEND="${RDEPEND}
		media-video/vdr"

PATCHES=(
	"${FILESDIR}/${PN}-1.0.2-freetype_pkgconfig.patch"
)

CONFIG_CHECK="~IR_IMON"

pkg_setup() {
	linux-info_pkg_setup
	vdr-plugin-2_pkg_setup
}

src_install() {
	rm -f README.git
	vdr-plugin-2_src_install

	insinto $(get_udevdir)/rules.d
	doins "${FILESDIR}"/99-imonlcd.rules
}
