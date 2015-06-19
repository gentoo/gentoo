# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/vdr-wapd/vdr-wapd-0.9.ebuild,v 1.3 2014/02/23 21:03:35 hd_brummy Exp $

EAPI=5

inherit vdr-plugin-2

DESCRIPTION="VDR plugin: lets VDR listen to WAP requests to allow remote control by WML enabled browsers"
HOMEPAGE="http://www.heiligenmann.de/vdr/vdr/plugins/wapd.html"
SRC_URI="http://www.heiligenmann.de/vdr/download/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

DEPEND=">=media-video/vdr-1.3.44"

PATCHES=("${FILESDIR}/${P}_gcc-4.1.x.diff"
	"${FILESDIR}/${P}-gentoo.diff")

src_install() {
	vdr-plugin-2_src_install

	dobin "${S}/wappasswd"

	insinto /etc/vdr/plugins/wapd
	doins "${FILESDIR}"/{waphosts,wapaccess}
}
