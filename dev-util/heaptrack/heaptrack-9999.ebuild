# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

KDE_AUTODEPS="false"
KDE_TEST="forceoptional"
inherit kde5

DESCRIPTION="A fast heap memory profiler"
HOMEPAGE="http://milianw.de/blog/heaptrack-a-heap-memory-profiler-for-linux"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS=""
IUSE="+qt5"

COMMON_DEPEND="
	dev-libs/boost:=
	sys-libs/libunwind
	sys-libs/zlib
	qt5? (
		$(add_frameworks_dep kconfig)
		$(add_frameworks_dep kconfigwidgets)
		$(add_frameworks_dep kcoreaddons)
		$(add_frameworks_dep ki18n)
		$(add_frameworks_dep kio)
		$(add_frameworks_dep kitemmodels)
		$(add_frameworks_dep kwidgetsaddons)
		$(add_frameworks_dep threadweaver)
		$(add_qt_dep qtcore)
		$(add_qt_dep qtgui)
		$(add_qt_dep qtwidgets)
		dev-libs/kdiagram:5
	)
"
DEPEND="${COMMON_DEPEND}
	$(add_frameworks_dep extra-cmake-modules)
"
RDEPEND="${COMMON_DEPEND}
	qt5? ( >=kde-frameworks/kf-env-4 )
"

src_configure() {
	local mycmakeargs=(
		-DHEAPTRACK_BUILD_GUI=$(usex qt5)
	)

	kde5_src_configure
}
