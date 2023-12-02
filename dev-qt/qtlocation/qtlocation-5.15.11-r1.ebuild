# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PATCHSET="${P}-patchset"
inherit qt5-build

DESCRIPTION="Location (places, maps, navigation) library for the Qt5 framework"

if [[ ${QT5_BUILD_TYPE} == release ]]; then
	MAPBOXGL_COMMIT=4c88f2c0e61daa89f584a8a9a3eba210221c6920
	SRC_URI+=" https://invent.kde.org/qt/qt/${PN}-mapboxgl/-/archive/${MAPBOXGL_COMMIT}/${PN}-mapboxgl-${MAPBOXGL_COMMIT}.tar.gz -> ${PN}-mapboxgl-${PV}-${MAPBOXGL_COMMIT:0:8}.tar.gz
	https://dev.gentoo.org/~asturm/distfiles/${PATCHSET}.tar.xz"
	KEYWORDS="amd64 arm arm64 ~ppc64 ~riscv ~x86"
fi

RDEPEND="
	dev-libs/icu:=
	=dev-qt/qtcore-${QT5_PV}*
	=dev-qt/qtdeclarative-${QT5_PV}*
	=dev-qt/qtgui-${QT5_PV}*
	=dev-qt/qtnetwork-${QT5_PV}*
	=dev-qt/qtpositioning-${QT5_PV}*[qml]
	=dev-qt/qtsql-${QT5_PV}*
	sys-libs/zlib
"
DEPEND="${RDEPEND}
	=dev-qt/qtconcurrent-${QT5_PV}*
"

QT5_TARGET_SUBDIRS=(
	src/3rdparty/clipper
	src/3rdparty/poly2tri
	src/3rdparty/clip2tri
	src/3rdparty/mapbox-gl-native
	src/location
	src/imports/location
	src/imports/locationlabs
	src/plugins/geoservices
)

if [[ ${QT5_BUILD_TYPE} == release ]]; then

PATCHES=( "${WORKDIR}/${PATCHSET}" )

src_prepare() {
	rm -rf src/3rdparty/mapbox-gl-native/* || die
	mv "${WORKDIR}"/${PN}-mapboxgl-${MAPBOXGL_COMMIT}/* src/3rdparty/mapbox-gl-native || die
	qt5-build_src_prepare
}
fi

src_configure() {
	# src/plugins/geoservices requires files that are only generated when
	# qmake is run in the root directory. Bug 633776.
	qt5_configure_oos_quirk qtlocation-config.pri src/location
	qt5-build_src_configure
}
