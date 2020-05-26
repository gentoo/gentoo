# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

ECM_HANDBOOK="forceoptional"
KFMIN=5.60.0
QTMIN=5.12.3
inherit ecm kde.org

DESCRIPTION="Desktop Planetarium"
HOMEPAGE="https://kde.org/applications/education/org.kde.kstars
https://edu.kde.org/kstars/"

if [[ ${KDE_BUILD_TYPE} = release ]]; then
	SRC_URI="mirror://kde/stable/${PN}/${P}.tar.xz"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="GPL-2+ GPL-3+"
SLOT="5"
IUSE="fits indi +password raw wcs"

REQUIRED_USE="indi? ( fits ) ${PYTHON_REQUIRED_USE}"

COMMON_DEPEND="
	>=dev-qt/qtdatavis3d-${QTMIN}:5
	>=dev-qt/qtdbus-${QTMIN}:5
	>=dev-qt/qtdeclarative-${QTMIN}:5
	>=dev-qt/qtgui-${QTMIN}:5
	>=dev-qt/qtnetwork-${QTMIN}:5
	>=dev-qt/qtprintsupport-${QTMIN}:5
	>=dev-qt/qtsql-${QTMIN}:5
	>=dev-qt/qtsvg-${QTMIN}:5
	>=dev-qt/qtwebsockets-${QTMIN}:5
	>=dev-qt/qtwidgets-${QTMIN}:5
	>=kde-frameworks/kauth-${KFMIN}:5
	>=kde-frameworks/kconfig-${KFMIN}:5
	>=kde-frameworks/kconfigwidgets-${KFMIN}:5
	>=kde-frameworks/kcoreaddons-${KFMIN}:5
	>=kde-frameworks/kcrash-${KFMIN}:5
	>=kde-frameworks/ki18n-${KFMIN}:5
	>=kde-frameworks/kio-${KFMIN}:5
	>=kde-frameworks/knewstuff-${KFMIN}:5
	>=kde-frameworks/knotifications-${KFMIN}:5
	>=kde-frameworks/knotifyconfig-${KFMIN}:5
	>=kde-frameworks/kplotting-${KFMIN}:5
	>=kde-frameworks/kwidgetsaddons-${KFMIN}:5
	>=kde-frameworks/kxmlgui-${KFMIN}:5
	sys-libs/zlib
	fits? ( sci-libs/cfitsio )
	indi? (
		>=sci-libs/indilib-1.7.5
		sci-libs/libnova
	)
	password? ( dev-libs/qtkeychain:= )
	raw? ( media-libs/libraw:= )
	wcs? ( sci-astronomy/wcslib )
"
# TODO: Add back when re-enabled by upstream
# 	opengl? (
# 		>=dev-qt/qtopengl-${QTMIN}:5
# 		virtual/opengl
# 	)
DEPEND="${COMMON_DEPEND}
	dev-cpp/eigen:3
	>=dev-qt/qtconcurrent-${QTMIN}:5
"
RDEPEND="${COMMON_DEPEND}
	>=dev-qt/qtgraphicaleffects-${QTMIN}:5
	>=dev-qt/qtpositioning-${QTMIN}:5
	>=dev-qt/qtquickcontrols-${QTMIN}:5
	>=dev-qt/qtquickcontrols2-${QTMIN}:5
"

PATCHES=( "${FILESDIR}/${P}-cfitsio-optional.patch" )

src_configure() {
	local mycmakeargs=(
		-DFETCH_TRANSLATIONS=OFF
		-DBUILD_DOC=$(usex handbook)
		$(cmake_use_find_package fits CFitsio)
		$(cmake_use_find_package indi INDI)
		$(cmake_use_find_package password Qt5Keychain)
		$(cmake_use_find_package raw LibRaw)
		$(cmake_use_find_package wcs WCSLIB)
	)

	ecm_src_configure
}

pkg_postinst () {
	ecm_pkg_postinst

	if [[ -z "${REPLACING_VERSIONS}" ]] && ! has_version "x11-misc/xplanet" ; then
		elog "${PN} has optional runtime support for x11-misc/xplanet"
	fi
	# same for AstrometryNet, which is not packaged.
}
