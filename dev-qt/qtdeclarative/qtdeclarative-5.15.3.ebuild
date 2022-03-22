# Copyright 2009-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

QT5_KDEPATCHSET_REV=1
PYTHON_COMPAT=( python3_{8..10} )
inherit python-any-r1 qt5-build

DESCRIPTION="The QML and Quick modules for the Qt5 framework"

if [[ ${QT5_BUILD_TYPE} == release ]]; then
	KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~riscv ~sparc ~x86"
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

src_prepare() {
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
		$(qt_use jit feature-qml-jit)
	)
	qt5-build_src_configure
}

src_install() {
	qt5-build_src_install
	qt5_symlink_binary_to_path qml 5
	qt5_symlink_binary_to_path qmleasing 5
	qt5_symlink_binary_to_path qmljs 5
	qt5_symlink_binary_to_path qmlpreview 5
	qt5_symlink_binary_to_path qmlscene 5
}
