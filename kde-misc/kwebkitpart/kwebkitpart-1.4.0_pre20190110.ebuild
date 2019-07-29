# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

COMMIT="ed6b8c87fabeb563109a093c1f79eeb03867b053"
inherit kde5

DESCRIPTION="WebKit KPart for Konqueror"
HOMEPAGE="https://cgit.kde.org/kwebkitpart.git"
SRC_URI="https://github.com/KDE/${PN}/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2"
KEYWORDS="amd64 arm64 x86"
IUSE=""

DEPEND="
	$(add_frameworks_dep kcompletion)
	$(add_frameworks_dep kconfig)
	$(add_frameworks_dep kcoreaddons)
	$(add_frameworks_dep kdewebkit)
	$(add_frameworks_dep ki18n)
	$(add_frameworks_dep kiconthemes)
	$(add_frameworks_dep kio)
	$(add_frameworks_dep kparts)
	$(add_frameworks_dep kservice)
	$(add_frameworks_dep kwidgetsaddons)
	$(add_frameworks_dep kxmlgui)
	$(add_frameworks_dep sonnet)
	$(add_qt_dep qtdbus)
	$(add_qt_dep qtgui)
	$(add_qt_dep qtprintsupport)
	$(add_qt_dep qtwidgets)
	>=dev-qt/qtwebkit-5.212.0_pre20180120:5
"
RDEPEND="${DEPEND}
	!kde-misc/kwebkitpart:4
"

S="${WORKDIR}/${PN}-${COMMIT}"
