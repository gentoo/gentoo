# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit kde4-base

DESCRIPTION="Video player plugin for Konqueror and basic MPlayer frontend"
HOMEPAGE="https://projects.kde.org/projects/extragear/multimedia/kmplayer"
COMMIT_ID="a28ff105e76a227b799c2bbf6e732791de5fb84e"
SRC_URI="https://quickgit.kde.org/?p=kmplayer.git&a=snapshot&h=${COMMIT_ID}&fmt=tbz2 -> ${P}.tar.bz2"

LICENSE="GPL-2 FDL-1.2 LGPL-2.1"
SLOT="4"
KEYWORDS="~amd64 ~x86"
IUSE="cairo debug expat npp"

DEPEND="
	media-libs/phonon[qt4]
	x11-libs/libX11
	cairo? (
		x11-libs/cairo
		x11-libs/pango
	)
	expat? ( >=dev-libs/expat-2.0.1 )
	npp? (
		$(add_kdeapps_dep kreadconfig)
		dev-libs/dbus-glib
		www-plugins/adobe-flash
		>=x11-libs/gtk+-2.10.14:2
	)
"
RDEPEND="${DEPEND}
	media-video/mplayer
"

PATCHES=( "${FILESDIR}/${PN}-0.11.3d-cmake34.patch" )

S="${WORKDIR}/${PN}"

src_prepare() {
	use npp && epatch "${FILESDIR}/${PN}-flash.patch"
	sed -e '/add_subdirectory(icons)/d' \
		-i CMakeLists.txt || die

	kde4-base_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DKMPLAYER_BUILT_WITH_CAIRO=$(usex cairo)
		-DKMPLAYER_BUILT_WITH_EXPAT=$(usex expat)
		-DKMPLAYER_BUILT_WITH_NPP=$(usex npp)
	)

	kde4-base_src_configure
}

src_install() {
	kde4-base_src_install

	if use npp; then
		kwriteconfig --file "${ED}/usr/share/config/kmplayerrc" --group "application/x-shockwave-flash" --key player npp
		kwriteconfig --file "${ED}/usr/share/config/kmplayerrc" --group "application/x-shockwave-flash" --key plugin /usr/lib/nsbrowser/plugins/libflashplayer.so
	fi
}
