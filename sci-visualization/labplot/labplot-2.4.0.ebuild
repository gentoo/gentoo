# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

EGIT_BRANCH="frameworks"
KDE_HANDBOOK="forceoptional"
inherit kde5

DESCRIPTION="Scientific data analysis and visualisation based on KDE Frameworks"
HOMEPAGE="https://www.kde.org/applications/education/labplot/"
[[ ${KDE_BUILD_TYPE} != live ]] && SRC_URI="mirror://kde/stable/${PN}/${PV}/${P}-kf5.tar.xz"

LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
IUSE="cantor fftw fits hdf5 netcdf"

[[ ${KDE_BUILD_TYPE} != live ]] && S="${WORKDIR}/${P}-kf5"

COMMON_DEPEND="
	$(add_frameworks_dep karchive)
	$(add_frameworks_dep kcompletion)
	$(add_frameworks_dep kconfig)
	$(add_frameworks_dep kconfigwidgets)
	$(add_frameworks_dep kcoreaddons)
	$(add_frameworks_dep kdelibs4support)
	$(add_frameworks_dep ki18n)
	$(add_frameworks_dep kiconthemes)
	$(add_frameworks_dep kio)
	$(add_frameworks_dep ktextwidgets)
	$(add_frameworks_dep kwidgetsaddons)
	$(add_frameworks_dep kxmlgui)
	$(add_qt_dep qtconcurrent)
	$(add_qt_dep qtgui)
	$(add_qt_dep qtprintsupport)
	$(add_qt_dep qtsvg)
	$(add_qt_dep qtwidgets)
	>=sci-libs/gsl-1.15:=
	cantor? ( $(add_kdeapps_dep cantor) )
	fftw? ( sci-libs/fftw:3.0= )
	fits? ( sci-libs/cfitsio:= )
	hdf5? ( sci-libs/hdf5:= )
	netcdf? ( sci-libs/netcdf:= )
"
DEPEND="${COMMON_DEPEND}
	sys-devel/gettext
	x11-misc/shared-mime-info
"
RDEPEND="${COMMON_DEPEND}
	!sci-visualization/labplot:4
"

src_prepare() {
	kde5_src_prepare

	if ! use handbook && [[ ${KDE_BUILD_TYPE} != live ]]; then
		cmake_comment_add_subdirectory doc-translations
	fi

	punt_bogus_dep KF5 NewStuff
}

src_configure() {
	local mycmakeargs=(
		-DENABLE_CANTOR=$(usex cantor)
		-DENABLE_FFTW=$(usex fftw)
		-DENABLE_FITS=$(usex fits)
		-DENABLE_HDF5=$(usex hdf5)
		-DENABLE_NETCDF=$(usex netcdf)
	)

	kde5_src_configure
}
