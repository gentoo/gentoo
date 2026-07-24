# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CARGO_OPTIONAL=1
CRATES="
"
RUST_MIN_VER="1.87.0"

ECM_HANDBOOK="forceoptional"
KFMIN=6.26.0
QTMIN=6.10.1
inherit cargo ecm flag-o-matic plasma.kde.org optfeature xdg

DESCRIPTION="Extra Plasma applets and engines"

if [[ ${KDE_BUILD_TYPE} == release ]] && [[ ${PKGBUMPING} != ${PVR} ]]; then
	SRC_URI+=" https://github.com/gentoo-crate-dist/${PN}/releases/download/v${PV}/${P}-crates.tar.xz"
fi

LICENSE="GPL-2 LGPL-2"
# Dependent crate licenses
LICENSE+=" GPL-3 MIT Unicode-3.0 ZLIB"
SLOT="6"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~riscv ~x86"
IUSE="+alternate-calendar led share webengine"

RESTRICT="test" # bug 727846, +missing selenium-webdriver-at-spi

DEPEND="
	>=dev-qt/qtbase-${QTMIN}:6[dbus,gui,network,widgets]
	>=dev-qt/qtdeclarative-${QTMIN}:6
	>=kde-frameworks/kcmutils-${KFMIN}:6
	>=kde-frameworks/kconfig-${KFMIN}:6
	>=kde-frameworks/kconfigwidgets-${KFMIN}:6
	>=kde-frameworks/kcoreaddons-${KFMIN}:6
	>=kde-frameworks/kdeclarative-${KFMIN}:6
	>=kde-frameworks/kglobalaccel-${KFMIN}:6
	>=kde-frameworks/kguiaddons-${KFMIN}:6
	>=kde-frameworks/kholidays-${KFMIN}:6
	>=kde-frameworks/ki18n-${KFMIN}:6
	>=kde-frameworks/kio-${KFMIN}:6
	>=kde-frameworks/kjobwidgets-${KFMIN}:6
	>=kde-frameworks/knewstuff-${KFMIN}:6
	>=kde-frameworks/knotifications-${KFMIN}:6
	>=kde-frameworks/kpackage-${KFMIN}:6
	>=kde-frameworks/krunner-${KFMIN}:6
	>=kde-frameworks/kservice-${KFMIN}:6
	>=kde-frameworks/ksvg-${KFMIN}:6
	>=kde-frameworks/kunitconversion-${KFMIN}:6
	>=kde-frameworks/kwidgetsaddons-${KFMIN}:6
	>=kde-frameworks/kxmlgui-${KFMIN}:6
	>=kde-frameworks/sonnet-${KFMIN}:6
	>=kde-plasma/libplasma-${KDE_CATV}:6=
	alternate-calendar? ( dev-libs/icu:= )
	led? (
		>=kde-frameworks/kauth-${KFMIN}:6
		>=kde-frameworks/kdbusaddons-${KFMIN}:6
	)
	share? ( >=kde-frameworks/purpose-${KFMIN}:6 )
	webengine? ( >=dev-qt/qtwebengine-${QTMIN}:6 )
"
RDEPEND="${DEPEND}
	!<kde-plasma/plasma-workspace-6.4.80
	dev-libs/kirigami-addons:6
	>=dev-qt/qtquick3d-${QTMIN}:6
	>=kde-frameworks/kirigami-${KFMIN}:6
	>=kde-frameworks/kitemmodels-${KFMIN}:6
"
BDEPEND="
	led? (
		${RUST_DEPEND}
		dev-build/corrosion
	)
"

pkg_setup() {
	use led && rust_pkg_setup
}

src_prepare() {
	ecm_src_prepare
	# TODO: upstream build switch?
	if ! use led; then
		cmake_comment_add_subdirectory kdeds
		ecm_punt_bogus_dep Corrosion
		ecm_punt_bogus_dep KF6 Auth
		ecm_punt_bogus_dep KF6 DBusAddons
	fi
}

src_configure() {
	# Rust extensions are incompatible with C/C++ LTO compiler see e.g.
	# https://bugs.gentoo.org/910220
	filter-lto

	local mycmakeargs=(
		$(cmake_use_find_package alternate-calendar ICU)
		$(cmake_use_find_package share KF6Purpose)
		$(cmake_use_find_package webengine Qt6WebEngineQuick)
	)

	ecm_src_configure
}

pkg_postinst() {
	optfeature "Disk quota applet" "sys-fs/quota"
	xdg_pkg_postinst
}
