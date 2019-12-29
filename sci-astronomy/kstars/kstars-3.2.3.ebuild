# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

KDE_HANDBOOK="forceoptional"
PYTHON_COMPAT=( python2_7 )
inherit kde5 python-single-r1

if [[ ${KDE_BUILD_TYPE} = release ]]; then
	SRC_URI="mirror://kde/stable/${PN}/${P}.tar.xz"
	KEYWORDS="amd64 x86"
fi

DESCRIPTION="Desktop Planetarium"
HOMEPAGE="https://kde.org/applications/education/kstars https://edu.kde.org/kstars/"
IUSE="fits indi +password raw wcs"

REQUIRED_USE="indi? ( fits ) ${PYTHON_REQUIRED_USE}"

COMMON_DEPEND="
	$(add_frameworks_dep kauth)
	$(add_frameworks_dep kconfig)
	$(add_frameworks_dep kconfigwidgets)
	$(add_frameworks_dep kcoreaddons)
	$(add_frameworks_dep kcrash)
	$(add_frameworks_dep ki18n)
	$(add_frameworks_dep kio)
	$(add_frameworks_dep knewstuff)
	$(add_frameworks_dep knotifications)
	$(add_frameworks_dep knotifyconfig)
	$(add_frameworks_dep kplotting)
	$(add_frameworks_dep kwidgetsaddons)
	$(add_frameworks_dep kxmlgui)
	$(add_qt_dep qtdatavis3d)
	$(add_qt_dep qtdbus)
	$(add_qt_dep qtdeclarative)
	$(add_qt_dep qtgui)
	$(add_qt_dep qtnetwork)
	$(add_qt_dep qtprintsupport)
	$(add_qt_dep qtsql)
	$(add_qt_dep qtsvg)
	$(add_qt_dep qtwebsockets)
	$(add_qt_dep qtwidgets)
	sys-libs/zlib
	fits? ( sci-libs/cfitsio )
	indi? ( >=sci-libs/indilib-1.7.5 )
	password? ( dev-libs/qtkeychain:= )
	raw? ( media-libs/libraw:= )
	wcs? ( sci-astronomy/wcslib )
"
# TODO: Add back when re-enabled by upstream
# 	opengl? (
# 		$(add_qt_dep qtopengl)
# 		virtual/opengl
# 	)
DEPEND="${COMMON_DEPEND}
	$(add_qt_dep qtconcurrent)
	dev-cpp/eigen:3
"
RDEPEND="${COMMON_DEPEND}
	${PYTHON_DEPS}
"

src_configure() {
	local mycmakeargs=(
		-DFETCH_TRANSLATIONS=OFF
		$(cmake_use_find_package fits CFitsio)
		$(cmake_use_find_package indi INDI)
		$(cmake_use_find_package password Qt5Keychain)
		$(cmake_use_find_package raw LibRaw)
		$(cmake_use_find_package wcs WCSLIB)
	)

	kde5_src_configure
}

pkg_postinst () {
	kde5_pkg_postinst

	if [[ -z "${REPLACING_VERSIONS}" ]] && ! has_version "x11-misc/xplanet" ; then
		elog "${PN} has optional runtime support for x11-misc/xplanet"
	fi
	# same for AstrometryNet, which is not packaged.
}
