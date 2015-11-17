# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

KDE_LINGUAS="bg bs ca ca@valencia cs da de el en_GB eo es et fr ga gl hr hu it
ja km ku lt lv mai nb nds nl nn pl pt pt_BR ro ru sk sr sr@latin sv th tr ug uk
zh_CN zh_TW"
KDE_HANDBOOK="optional"
inherit kde4-base

DESCRIPTION="Video player plugin for Konqueror and basic MPlayer frontend"
HOMEPAGE="https://projects.kde.org/projects/extragear/multimedia/kmplayer"
SRC_URI="https://kmplayer.kde.org/pkgs/${P}.tar.bz2"

LICENSE="GPL-2 FDL-1.2 LGPL-2.1"
SLOT="4"
KEYWORDS="amd64 x86"
IUSE="cairo debug expat npp"

DEPEND="
	media-libs/phonon[qt4]
	x11-libs/libX11
	expat? ( >=dev-libs/expat-2.0.1 )
	cairo? (
		x11-libs/cairo
		x11-libs/pango
	)
	npp? (
		dev-libs/dbus-glib
		$(add_kdeapps_dep kreadconfig)
		>=x11-libs/gtk+-2.10.14:2
		www-plugins/adobe-flash
	)
"
RDEPEND="${DEPEND}
	media-video/mplayer
"

PATCHES=( "${FILESDIR}/${P}-kdelibs-4.14.11.patch" )

src_prepare() {
	use npp && epatch "${FILESDIR}/${PN}-flash.patch"
	sed -e '/add_subdirectory(icons)/d' \
		-i CMakeLists.txt || die

	kde4-base_src_prepare
}

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use cairo KMPLAYER_BUILT_WITH_CAIRO)
		$(cmake-utils_use expat KMPLAYER_BUILT_WITH_EXPAT)
		$(cmake-utils_use npp KMPLAYER_BUILT_WITH_NPP)
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
