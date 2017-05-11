# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

KDE_GCC_MINIMAL="4.9"
QT_MINIMAL="5.7.1"
inherit cmake-utils gnome2-utils kde5-functions

DESCRIPTION="Elegant dock, based on KDE Frameworks"
HOMEPAGE="https://store.kde.org/p/1169519/
https://github.com/psifidotos/Latte-Dock"

if [[ ${PV} = 9999 ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/psifidotos/Latte-Dock.git"
else
	SRC_URI="https://github.com/psifidotos/Latte-Dock/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
	S="${WORKDIR}/Latte-Dock-${PV}"
fi

LICENSE="GPL-2+"
SLOT="0"
IUSE=""

RDEPEND="
	$(add_frameworks_dep kactivities)
	$(add_frameworks_dep karchive)
	$(add_frameworks_dep kconfig)
	$(add_frameworks_dep kcoreaddons)
	$(add_frameworks_dep kdbusaddons)
	$(add_frameworks_dep kdeclarative)
	$(add_frameworks_dep kglobalaccel)
	$(add_frameworks_dep ki18n)
	$(add_frameworks_dep kiconthemes)
	$(add_frameworks_dep knotifications)
	$(add_frameworks_dep kpackage)
	$(add_frameworks_dep kwayland)
	$(add_frameworks_dep kwindowsystem)
	$(add_frameworks_dep kxmlgui)
	$(add_frameworks_dep plasma X)
	$(add_qt_dep qtcore)
	$(add_qt_dep qtdbus)
	$(add_qt_dep qtdeclarative)
	$(add_qt_dep qtgraphicaleffects)
	$(add_qt_dep qtgui 'xcb')
	$(add_qt_dep qtwidgets)
	$(add_qt_dep qtx11extras)
	x11-libs/libX11
	x11-libs/libxcb
"
DEPEND="${RDEPEND}
	$(add_frameworks_dep extra-cmake-modules)
"

DOCS=( CHANGELOG.md README.md TRANSLATORS )

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	gnome2_icon_cache_update

	if has_version ">=dev-qt/qtcore-5.8.0" ; then
		ewarn "Qt versions >=5.8 are known to cause runtime problems. If you"
		ewarn "experience problems while running Latte Dock, please check this"
		ewarn "out: https://github.com/psifidotos/Latte-Dock/issues/183"
	fi
}

pkg_postrm() {
	gnome2_icon_cache_update
}
