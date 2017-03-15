# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

COMMIT="a201df47a0849a09a20617fedfee26a407dc847c"
inherit kde5 vcs-snapshot

DESCRIPTION="Simple photo taking application with fancy animated interface"
HOMEPAGE="http://dos1.github.io/kamerka/ https://github.com/dos1/kamerka"
SRC_URI="https://github.com/dos1/${PN}/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="
	$(add_frameworks_dep kcompletion)
	$(add_frameworks_dep kconfig)
	$(add_frameworks_dep kconfigwidgets)
	$(add_frameworks_dep kcoreaddons)
	$(add_frameworks_dep kdeclarative)
	$(add_frameworks_dep kdelibs4support)
	$(add_frameworks_dep ki18n)
	$(add_frameworks_dep kio)
	$(add_frameworks_dep knotifications)
	$(add_frameworks_dep kwidgetsaddons)
	$(add_frameworks_dep kxmlgui)
	$(add_qt_dep qtgui)
	$(add_qt_dep qtdeclarative)
	$(add_qt_dep qtscript)
	$(add_qt_dep qtwidgets)
	media-libs/libv4l
	media-libs/phonon[qt5]
	media-libs/qimageblitz[qt5]
"
RDEPEND="${DEPEND}"
