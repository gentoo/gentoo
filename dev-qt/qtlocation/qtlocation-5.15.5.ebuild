# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

QT5_KDEPATCHSET_REV=1
inherit qt5-build

DESCRIPTION="Location (places, maps, navigation) library for the Qt5 framework"

if [[ ${QT5_BUILD_TYPE} == release ]]; then
	KEYWORDS="amd64 arm arm64 ppc64 ~riscv x86"
fi

IUSE=""

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

src_configure() {
	# src/plugins/geoservices requires files that are only generated when
	# qmake is run in the root directory. Bug 633776.
	mkdir -p "${QT5_BUILD_DIR}"/src/location || die
	qt5_qmake "${QT5_BUILD_DIR}"
	cp "${S}"/src/location/qtlocation-config.pri "${QT5_BUILD_DIR}"/src/location || die
	qt5-build_src_configure
}
