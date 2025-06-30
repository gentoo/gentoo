# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_TEST="true"
KFMIN=6.13.0
QTMIN=6.7.2
PYTHON_COMPAT=( python3_{11..13} )
inherit ecm gear.kde.org python-single-r1 xdg

DESCRIPTION="Cross-platform web browser using QtWebEngine"
HOMEPAGE="https://www.falkon.org/ https://apps.kde.org/falkon/"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 ~arm64"
IUSE="dbus kde python +X"

REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"
RESTRICT="test" # bug 653046

COMMON_DEPEND="
	dev-libs/openssl:0=
	>=dev-qt/qt5compat-${QTMIN}:6
	>=dev-qt/qtbase-${QTMIN}:6[dbus?,gui,network,sql,sqlite,ssl,widgets]
	>=dev-qt/qtdeclarative-${QTMIN}:6[widgets]
	>=dev-qt/qtwebchannel-${QTMIN}:6
	>=dev-qt/qtwebengine-${QTMIN}:6=[widgets]
	>=kde-frameworks/karchive-${KFMIN}:6
	virtual/libintl
	kde? (
		>=kde-frameworks/kcoreaddons-${KFMIN}:6
		>=kde-frameworks/kcrash-${KFMIN}:6
		>=kde-frameworks/kio-${KFMIN}:6
		>=kde-frameworks/kjobwidgets-${KFMIN}:6
		>=kde-frameworks/kwallet-${KFMIN}:6
		>=kde-frameworks/purpose-${KFMIN}:6
	)
	python? (
		${PYTHON_DEPS}
		$(python_gen_cond_dep "
			>=dev-python/pyside-${QTMIN}:6[gui,positioning,uitools(-),webengine,widgets,\${PYTHON_USEDEP}]
		")
	)
	X? (
		x11-libs/libxcb:=
		x11-libs/xcb-util
	)
"
DEPEND="${COMMON_DEPEND}
	>=dev-qt/qtbase-${QTMIN}:6[concurrent]
"
if [[ ${KDE_BUILD_TYPE} != live ]]; then
	DEPEND+=" >=kde-frameworks/ki18n-${KFMIN}:6"
fi
RDEPEND="${COMMON_DEPEND}
	>=dev-qt/qtsvg-${QTMIN}:6
"
BDEPEND=">=dev-qt/qttools-${QTMIN}:6[linguist]"

pkg_setup() {
	use python && python-single-r1_pkg_setup
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_KEYRING=OFF
		-DDISABLE_DBUS=$(usex !dbus)
		$(cmake_use_find_package kde KF6Wallet)
		$(cmake_use_find_package kde KF6KIO)
		-DBUILD_PYTHON_SUPPORT=$(usex python)
		-DNO_X11=$(usex !X)
	)
	use python && mycmakeargs+=(
		-DPYTHON_CONFIG_SUFFIX="-${EPYTHON}" # shiboken_helpers.cmake quirk
		-DPython3_INCLUDE_DIR=$(python_get_includedir)
		-DPython3_LIBRARY=$(python_get_library_path)
	)
	ecm_src_configure
}
