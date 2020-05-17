# Copyright 2009-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{6,7,8} )
inherit python-any-r1 qt5-build

DESCRIPTION="The QML and Quick modules for the Qt5 framework"

if [[ ${QT5_BUILD_TYPE} == release ]]; then
	KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~sparc ~x86"
fi

IUSE="gles2-only +jit localstorage vulkan +widgets"

BDEPEND="${PYTHON_DEPS}"
# qtgui[gles2-only=] is needed because of bug 504322
DEPEND="
	~dev-qt/qtcore-${PV}
	~dev-qt/qtgui-${PV}[gles2-only=,vulkan=]
	~dev-qt/qtnetwork-${PV}
	~dev-qt/qttest-${PV}
	localstorage? ( ~dev-qt/qtsql-${PV} )
	widgets? ( ~dev-qt/qtwidgets-${PV}[gles2-only=] )
"
RDEPEND="${DEPEND}
	!<dev-qt/qtquickcontrols-5.7:5
"

PATCHES=(
	"${FILESDIR}/${P}-QQuickItemView-fix-maxXY-extent.patch" # QTBUG-83890
	"${FILESDIR}/${P}-fix-subpixel-positioned-text.patch" # QTBUG-49646
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
