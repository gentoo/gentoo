# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

# Qt 5.5 compat fixed in master
QT_MINIMAL="5.6"
inherit kde5

DESCRIPTION="Media player with digital TV support by KDE"
HOMEPAGE="https://kaffeine.kde.org/"
SRC_URI="mirror://kde/stable/${PN}/${PV}/src/${P}.tar.bz2"

LICENSE="GPL-2 FDL-1.2"
KEYWORDS="~amd64 ~x86"
IUSE=""

CDEPEND="
	$(add_frameworks_dep kconfig)
	$(add_frameworks_dep kconfigwidgets)
	$(add_frameworks_dep kcoreaddons)
	$(add_frameworks_dep kdbusaddons)
	$(add_frameworks_dep ki18n)
	$(add_frameworks_dep kio)
	$(add_frameworks_dep knotifications)
	$(add_frameworks_dep kwidgetsaddons)
	$(add_frameworks_dep kxmlgui)
	$(add_frameworks_dep solid)
	$(add_qt_dep qtdbus)
	$(add_qt_dep qtgui)
	$(add_qt_dep qtnetwork)
	$(add_qt_dep qtsql 'sqlite')
	$(add_qt_dep qtwidgets)
	$(add_qt_dep qtx11extras)
	$(add_qt_dep qtxml)
	media-libs/libv4l
	media-video/vlc[X]
	x11-libs/libXScrnSaver
"
DEPEND="${CDEPEND}
	sys-devel/gettext
	virtual/pkgconfig
"
RDEPEND="${CDEPEND}
	!media-video/kaffeine:4
"

DOCS=( Changelog NOTES README )

if [[ ${KDE_BUILD_TYPE} != live ]] ; then
	S="${WORKDIR}"
fi

src_configure() {
	# tools working on $HOME directory for a local git checkout
	local mycmakeargs=(
		-DBUILD_TOOLS=OFF
	)

	kde5_src_configure
}
