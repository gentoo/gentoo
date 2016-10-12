# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
PYTHON_COMPAT=( python2_7 python3_{4,5} )
inherit python-any-r1 qt5-build

DESCRIPTION="The QML and Quick modules for the Qt5 framework"

if [[ ${QT5_BUILD_TYPE} == release ]]; then
	KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~x86"
fi

IUSE="gles2 +jit localstorage +widgets xml"

# qtgui[gles2=] is needed because of bug 504322
RDEPEND="
	~dev-qt/qtcore-${PV}
	~dev-qt/qtgui-${PV}[gles2=]
	~dev-qt/qtnetwork-${PV}
	~dev-qt/qttest-${PV}
	localstorage? ( ~dev-qt/qtsql-${PV} )
	widgets? ( ~dev-qt/qtwidgets-${PV}[gles2=] )
	xml? (
		~dev-qt/qtnetwork-${PV}
		~dev-qt/qtxmlpatterns-${PV}
	)
"
DEPEND="${RDEPEND}
	${PYTHON_DEPS}
"

src_prepare() {
	use jit || PATCHES+=("${FILESDIR}/${PN}-5.4.2-disable-jit.patch")

	use localstorage || sed -i -e '/localstorage/d' \
		src/imports/imports.pro || die

	qt_use_disable_mod widgets widgets \
		src/src.pro \
		src/qmltest/qmltest.pro \
		tests/auto/auto.pro \
		tools/tools.pro \
		tools/qmlscene/qmlscene.pro \
		tools/qml/qml.pro

	qt_use_disable_mod xml xmlpatterns \
		src/imports/imports.pro \
		tests/auto/quick/quick.pro \
		tests/auto/quick/examples/examples.pro

	qt5-build_src_prepare
}
