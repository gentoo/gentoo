# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
QT5_MODULE="qtlocation"
inherit qt5-build

DESCRIPTION="Physical position determination library for the Qt5 framework"

if [[ ${QT5_BUILD_TYPE} == release ]]; then
	KEYWORDS="~amd64 ~arm ~hppa ~ppc64 ~x86"
fi

# TODO: src/plugins/position/gypsy
IUSE="geoclue qml"

RDEPEND="
	~dev-qt/qtcore-${PV}
	geoclue? (
		app-misc/geoclue:0
		dev-libs/glib:2
	)
	qml? (
		~dev-qt/qtdeclarative-${PV}
		~dev-qt/qtnetwork-${PV}
	)
"
DEPEND="${RDEPEND}"

QT5_TARGET_SUBDIRS=(
	src/positioning
	src/plugins/position/positionpoll
)

pkg_setup() {
	use geoclue && QT5_TARGET_SUBDIRS+=(src/plugins/position/geoclue)
	use qml && QT5_TARGET_SUBDIRS+=(src/imports/positioning)
}
