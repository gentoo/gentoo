# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/vdr-imonlcd/vdr-imonlcd-1.0.1.ebuild,v 1.1 2014/01/08 13:08:36 hd_brummy Exp $

EAPI=5

inherit vdr-plugin-2 linux-info udev

VERSION="1327" # every bump, new version

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

CONFIG_CHECK="~IR_IMON"

pkg_setup() {
	linux-info_pkg_setup
	vdr-plugin-2_pkg_setup
}

src_install() {
	rm -f README.git
	vdr-plugin-2_src_install

	insinto $(get_udevdir)/rules.d
	doins "${FILESDIR}"/99-imonlcd.rules || die
}
