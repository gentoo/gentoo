# Copyright 2009-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

KDE_ORG_COMMIT=1c33a9d045897ce755a818ebff7ddecae97885d3
PYTHON_COMPAT=( python3_{8..10} )
inherit python-any-r1 qt5-build

DESCRIPTION="The QML and Quick modules for the Qt5 framework"

if [[ ${QT5_BUILD_TYPE} == release ]]; then
	KEYWORDS="amd64 arm arm64 ~hppa ppc ppc64 ~riscv ~sparc x86"
fi

IUSE="gles2-only +jit localstorage vulkan +widgets"

# qtgui[gles2-only=] is needed because of bug 504322
DEPEND="
	=dev-qt/qtcore-${QT5_PV}*
	=dev-qt/qtgui-${QT5_PV}*:5=[gles2-only=,vulkan=]
	=dev-qt/qtnetwork-${QT5_PV}*
	=dev-qt/qttest-${QT5_PV}*
	media-libs/libglvnd
	localstorage? ( =dev-qt/qtsql-${QT5_PV}* )
	widgets? ( =dev-qt/qtwidgets-${QT5_PV}*[gles2-only=] )
"
RDEPEND="${DEPEND}"
BDEPEND="${PYTHON_DEPS}"

PATCHES=(
	"${FILESDIR}/${PN}-5.14.2-QQuickItemView-fix-maxXY-extent.patch" # QTBUG-83890
	"${FILESDIR}/${PN}-5.15.2-riscv-atomic.patch" # bug 790689
)

src_prepare() {
	use jit || PATCHES+=( "${FILESDIR}/${PN}-5.4.2-disable-jit.patch" )

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
