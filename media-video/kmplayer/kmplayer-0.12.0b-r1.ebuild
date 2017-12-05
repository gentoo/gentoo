# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

KDE_HANDBOOK="true"
inherit kde5

DESCRIPTION="Video player plugin for Konqueror and basic MPlayer frontend"
HOMEPAGE="https://kmplayer.kde.org"
SRC_URI="mirror://kde/stable/${PN}/${EGIT_BRANCH}/${P}.tar.bz2"

LICENSE="GPL-2 FDL-1.2 LGPL-2.1"
KEYWORDS="amd64 x86"
IUSE="cairo npp"

CDEPEND="
	$(add_frameworks_dep kbookmarks)
	$(add_frameworks_dep kcompletion)
	$(add_frameworks_dep kconfig)
	$(add_frameworks_dep kconfigwidgets)
	$(add_frameworks_dep kcoreaddons)
	$(add_frameworks_dep kdelibs4support)
	$(add_frameworks_dep ki18n)
	$(add_frameworks_dep kiconthemes)
	$(add_frameworks_dep kio)
	$(add_frameworks_dep kmediaplayer)
	$(add_frameworks_dep kparts)
	$(add_frameworks_dep ktextwidgets)
	$(add_frameworks_dep kwidgetsaddons)
	$(add_frameworks_dep kxmlgui)
	$(add_qt_dep qtdbus)
	$(add_qt_dep qtgui)
	$(add_qt_dep qtsvg)
	$(add_qt_dep qtwidgets)
	$(add_qt_dep qtx11extras)
	$(add_qt_dep qtxml)
	media-libs/phonon[qt5(+)]
	x11-libs/libX11
	x11-libs/libxcb
	cairo? ( x11-libs/cairo[xcb] )
	npp? (
		dev-libs/dbus-glib
		dev-libs/glib:2
		www-plugins/adobe-flash:*
		>=x11-libs/gtk+-2.10.14:2
	)
"
DEPEND="${CDEPEND}
	sys-devel/gettext
"
RDEPEND="${CDEPEND}
	media-video/mplayer
	!media-video/kmplayer:4
"

PATCHES=(
	"${FILESDIR}"/${P}-schedulerepaint.patch
	"${FILESDIR}"/${P}-devpixelratio.patch
	"${FILESDIR}"/${P}-qfile.patch
	"${FILESDIR}"/${P}-cmake.patch
	"${FILESDIR}"/${P}-desktop.patch
	"${FILESDIR}"/${P}-qt-5.9.patch
)

src_prepare() {
	# Prerequisite for ${P}-desktop.patch:
	mv src/kmplayer.desktop src/org.kde.kmplayer.desktop || die
	kde5_src_prepare

	if use npp; then
		sed -i src/kmplayer_part.desktop \
			-e ":^MimeType: s:=:=application/x-shockwave-flash;:" || die
	fi
}

src_configure() {
	# 0.12: expat build broken, check in later releases
	local mycmakeargs=(
		-DKMPLAYER_BUILT_WITH_EXPAT=OFF
		-DKMPLAYER_BUILT_WITH_CAIRO=$(usex cairo)
		-DKMPLAYER_BUILT_WITH_NPP=$(usex npp)
	)

	kde5_src_configure
}

src_install() {
	kde5_src_install

	if use npp; then
		kwriteconfig5 --file "${ED}/usr/share/config/kmplayerrc" \
			--group "application/x-shockwave-flash" --key player npp
		kwriteconfig5 --file "${ED}/usr/share/config/kmplayerrc" \
			--group "application/x-shockwave-flash" \
			--key plugin /usr/$(get_libdir)/nsbrowser/plugins/libflashplayer.so
	fi
}
