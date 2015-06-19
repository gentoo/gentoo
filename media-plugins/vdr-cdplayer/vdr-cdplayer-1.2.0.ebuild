# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/vdr-cdplayer/vdr-cdplayer-1.2.0.ebuild,v 1.1 2013/05/26 16:00:41 hd_brummy Exp $

EAPI="5"

inherit vdr-plugin-2

DESCRIPTION="VDR Plugin: CD-PLAYER"
HOMEPAGE="http://www.uli-eckhardt.de/vdr/cdplayer.en.shtml"
SRC_URI="http://www.uli-eckhardt.de/vdr/download/${P}.tgz"

KEYWORDS="~amd64 ~x86"
SLOT="0"
LICENSE="GPL-2"
IUSE="cdparanoia"

DEPEND=">=media-video/vdr-1.6"
RDEPEND="${DEPEND}
		>=dev-libs/libcdio-0.8.0
		>=dev-libs/libcdio-paranoia-0.90
		>=media-libs/libcddb-1.3.0"

src_prepare() {
	if has_version "<media-video/vdr-1.7.27"; then
		cp Makefile.old Makefile
	fi

	vdr-plugin-2_src_prepare

	use cdparanoia || BUILD_PARAMS="NOPARANOIA=1"
}

src_install() {
	vdr-plugin-2_src_install

	if has_version "<media-video/vdr-1.7.27"; then
		insinto /etc/vdr/plugins/"${VDRPLUGIN}"
		doins "${S}"/contrib/cd.mpg
	fi
}
