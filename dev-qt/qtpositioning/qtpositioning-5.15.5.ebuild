# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

QT5_MODULE="qtlocation"
inherit qt5-build

DESCRIPTION="Physical position determination library for the Qt5 framework"

if [[ ${QT5_BUILD_TYPE} == release ]]; then
	KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~riscv ~sparc ~x86"
fi

IUSE="geoclue +qml"

RDEPEND="
	=dev-qt/qtcore-${QT5_PV}*
	geoclue? ( =dev-qt/qtdbus-${QT5_PV}* )
	qml? ( =dev-qt/qtdeclarative-${QT5_PV}* )
"
DEPEND="${RDEPEND}"
PDEPEND="
	geoclue? ( app-misc/geoclue:2.0 )
"

QT5_TARGET_SUBDIRS=(
	src/3rdparty/clipper
	src/3rdparty/poly2tri
	src/3rdparty/clip2tri
	src/positioning
	src/plugins/position/positionpoll
)

pkg_setup() {
	use geoclue && QT5_TARGET_SUBDIRS+=( src/plugins/position/geoclue2 )
	use qml && QT5_TARGET_SUBDIRS+=(
		src/positioningquick
		src/imports/positioning
	)
}
