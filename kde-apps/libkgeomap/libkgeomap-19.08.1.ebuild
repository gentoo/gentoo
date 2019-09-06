# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

KDE_TEST="true"
VIRTUALX_REQUIRED="test"
inherit kde5

DESCRIPTION="Wrapper library for world map components as marble, openstreetmap and googlemap"
HOMEPAGE="https://www.digikam.org/"

LICENSE="GPL-2+"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE=""

DEPEND="
	$(add_frameworks_dep kconfig)
	$(add_frameworks_dep kcoreaddons)
	$(add_frameworks_dep ki18n)
	$(add_frameworks_dep kio)
	$(add_kdeapps_dep marble 'kde' '' '5=')
	$(add_qt_dep qtconcurrent)
	$(add_qt_dep qtgui)
	>=dev-qt/qtwebkit-5.212.0_pre20180120:5
	$(add_qt_dep qtwidgets)
	$(add_qt_dep qtxml)
"
RDEPEND="${DEPEND}"

src_configure() {
	use test && local mycmakeargs=( -DCMAKE_DISABLE_FIND_PACKAGE_KF5KExiv2=true )

	kde5_src_configure
}
