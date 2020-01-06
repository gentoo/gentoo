# Copyright 2009-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python2_7 python3_{6,7} )
inherit python-any-r1 qt5-build

DESCRIPTION="The QML and Quick modules for the Qt5 framework"

if [[ ${QT5_BUILD_TYPE} == release ]]; then
	KEYWORDS="amd64 ~arm arm64 ~hppa ~ppc ppc64 ~x86"
fi

IUSE="gles2 +jit localstorage +widgets"

BDEPEND="${PYTHON_DEPS}"
# qtgui[gles2=] is needed because of bug 504322
DEPEND="
	~dev-qt/qtcore-${PV}
	~dev-qt/qtgui-${PV}[gles2=]
	~dev-qt/qtnetwork-${PV}
	~dev-qt/qttest-${PV}
	localstorage? ( ~dev-qt/qtsql-${PV} )
	widgets? ( ~dev-qt/qtwidgets-${PV}[gles2=] )
"
RDEPEND="${DEPEND}
	!<dev-qt/qtquickcontrols-5.7:5
"

PATCHES=(
	"${FILESDIR}/${P}-read-QQmlPropertyMap-correctly.patch" # QTBUG-79614
	"${FILESDIR}/${P}-fix-deadlock-on-exit.patch" # QTBUG-79573
)

src_prepare() {
	use jit || PATCHES+=("${FILESDIR}/${PN}-5.4.2-disable-jit.patch")

	qt_use_disable_mod localstorage sql \
		src/imports/imports.pro

	qt_use_disable_mod widgets widgets \
		src/src.pro \
		src/qmltest/qmltest.pro \
		tests/auto/auto.pro \
		tools/tools.pro \
		tools/qmlscene/qmlscene.pro \
		tools/qml/qml.pro

	qt5-build_src_prepare
}

src_configure() {
	local myqmakeargs=(
		--
		-qml-debug
	)
	qt5-build_src_configure
}
