# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit kde5

DESCRIPTION="Simple photo taking application with fancy animated interface"
HOMEPAGE="https://dos1.github.io/kamerka/ https://github.com/dos1/kamerka"
SRC_URI="https://github.com/dos1/kamerka/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
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
	media-libs/phonon[qt5(+)]
	>=media-libs/qimageblitz-0.0.6_p20131029[qt5(+)]
"
RDEPEND="${DEPEND}
	$(add_qt_dep qtgraphicaleffects)
"
