# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_TEST="true"
KDE_GEAR="true"
KFMIN=5.92.0
QTMIN=5.15.3
PYTHON_COMPAT=( python3_{8..10} )
VIRTUALX_REQUIRED="test"
inherit ecm kde.org python-single-r1

DESCRIPTION="Cross-platform web browser using QtWebEngine"
HOMEPAGE="https://www.falkon.org/ https://apps.kde.org/falkon/"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE="dbus kde python +X"

REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"
RESTRICT="test" # bug 653046

COMMON_DEPEND="
	dev-libs/openssl:0=
	>=dev-qt/qtdeclarative-${QTMIN}:5[widgets]
	>=dev-qt/qtgui-${QTMIN}:5
	>=dev-qt/qtnetwork-${QTMIN}:5[ssl]
	>=dev-qt/qtprintsupport-${QTMIN}:5
	>=dev-qt/qtsql-${QTMIN}:5[sqlite]
	>=dev-qt/qtwebchannel-${QTMIN}:5
	>=dev-qt/qtwebengine-${QTMIN}:5=[widgets]
	>=dev-qt/qtwidgets-${QTMIN}:5
	>=kde-frameworks/karchive-${KFMIN}:5
	virtual/libintl
	dbus? ( >=dev-qt/qtdbus-${QTMIN}:5 )
	kde? (
		>=kde-frameworks/kcoreaddons-${KFMIN}:5
		>=kde-frameworks/kcrash-${KFMIN}:5
		>=kde-frameworks/kio-${KFMIN}:5
		>=kde-frameworks/kwallet-${KFMIN}:5
		>=kde-frameworks/purpose-${KFMIN}:5
	)
	python? (
		${PYTHON_DEPS}
		$(python_gen_cond_dep '
			dev-python/pyside2[designer,gui,webengine,widgets,${PYTHON_USEDEP}]
			dev-python/shiboken2[${PYTHON_USEDEP}]
		')
	)
	X? (
		>=dev-qt/qtx11extras-${QTMIN}:5
		x11-libs/libxcb:=
		x11-libs/xcb-util
	)
"
DEPEND="${COMMON_DEPEND}
	>=dev-qt/qtconcurrent-${QTMIN}:5
"
if [[ ${KDE_BUILD_TYPE} != live ]]; then
	DEPEND+=" >=kde-frameworks/ki18n-${KFMIN}:5"
fi
RDEPEND="${COMMON_DEPEND}
	>=dev-qt/qtsvg-${QTMIN}:5
"
BDEPEND="
	>=dev-qt/linguist-tools-${QTMIN}:5
"

pkg_setup() {
	python-single-r1_pkg_setup
	ecm_pkg_setup
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_KEYRING=OFF
		-DDISABLE_DBUS=$(usex !dbus)
		$(cmake_use_find_package kde KF5Wallet)
		$(cmake_use_find_package kde KF5KIO)
		$(cmake_use_find_package python PySide2)
		$(cmake_use_find_package python Shiboken2)
		$(cmake_use_find_package python Python3)
		-DNO_X11=$(usex !X)
	)
	ecm_src_configure
}
