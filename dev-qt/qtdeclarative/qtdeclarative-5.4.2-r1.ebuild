# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit qt5-build

DESCRIPTION="The QML and Quick modules for the Qt5 framework"

if [[ ${QT5_BUILD_TYPE} == release ]]; then
	KEYWORDS="amd64 arm ~arm64 hppa ppc64 ~x86"
fi

IUSE="gles2 +jit localstorage +widgets xml"

# qtgui[gles2=] is needed because of bug 504322
DEPEND="
	>=dev-qt/qtcore-${PV}:5
	>=dev-qt/qtgui-${PV}:5[gles2=]
	>=dev-qt/qtnetwork-${PV}:5
	>=dev-qt/qttest-${PV}:5
	localstorage? ( >=dev-qt/qtsql-${PV}:5 )
	widgets? ( >=dev-qt/qtwidgets-${PV}:5[gles2=] )
	xml? ( >=dev-qt/qtxmlpatterns-${PV}:5 )
"
RDEPEND="${DEPEND}"

src_prepare() {
	use jit || epatch "${FILESDIR}"/${PN}-5.4.2-disable-jit.patch

	use localstorage || sed -i -e '/localstorage/d' \
		src/imports/imports.pro || die

	use widgets || sed -i -e 's/contains(QT_CONFIG, no-widgets)/true/' \
		src/qmltest/qmltest.pro || die

	qt_use_disable_mod widgets widgets \
		src/src.pro \
		tools/tools.pro \
		tools/qmlscene/qmlscene.pro \
		tools/qml/qml.pro

	qt_use_disable_mod xml xmlpatterns \
		src/imports/imports.pro \
		tests/auto/quick/quick.pro

	qt5-build_src_prepare
}
