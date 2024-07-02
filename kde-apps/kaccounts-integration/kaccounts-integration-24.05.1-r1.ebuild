# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_TEST="forceoptional"
KF5MIN=5.115.0
KFMIN=6.3.0
PVCUT=$(ver_cut 1-3)
QT5MIN=5.15.12
QTMIN=6.6.2
VIRTUALDBUS_TEST="true"
inherit ecm gear.kde.org multibuild

DESCRIPTION="Administer web accounts for the sites and services across the Plasma desktop"
HOMEPAGE="https://community.kde.org/KTp"

LICENSE="LGPL-2.1"
SLOT="6"
KEYWORDS="~amd64 ~arm64"
IUSE="qt5"

# bug #549444
RESTRICT="test"

COMMON_DEPEND="
	>=dev-qt/qtbase-${QTMIN}:6[gui,widgets]
	>=dev-qt/qtdeclarative-${QTMIN}:6
	>=kde-frameworks/kconfig-${KFMIN}:6
	>=kde-frameworks/kcoreaddons-${KFMIN}:6
	>=kde-frameworks/kdbusaddons-${KFMIN}:6
	>=kde-frameworks/ki18n-${KFMIN}:6
	>=kde-frameworks/kio-${KFMIN}:6
	>=kde-frameworks/kwallet-${KFMIN}:6
	>=net-libs/accounts-qt-1.16_p20220803[qt5?,qt6]
	>=net-libs/signond-8.61-r100[qt5?,qt6]
	qt5? (
		>=dev-qt/qtdeclarative-${QT5MIN}:5
		>=dev-qt/qtgui-${QT5MIN}:5
		>=dev-qt/qtwidgets-${QT5MIN}:5
		>=kde-frameworks/kconfig-${KF5MIN}:5
		>=kde-frameworks/kcoreaddons-${KF5MIN}:5
		>=kde-frameworks/kdbusaddons-${KF5MIN}:5
		>=kde-frameworks/ki18n-${KF5MIN}:5
		>=kde-frameworks/kio-${KF5MIN}:5
		>=kde-frameworks/kwallet-${KF5MIN}:5
	)
"
DEPEND="${COMMON_DEPEND}
	dev-libs/qcoro
	>=kde-frameworks/kcmutils-${KFMIN}:6
	kde-plasma/kde-cli-tools:*
	qt5? (
		dev-libs/qcoro5
		>=kde-frameworks/kcmutils-${KF5MIN}:5
	)
"
# KAccountsMacros.cmake needs intltool; TODO: Watch:
# https://invent.kde.org/network/kaccounts-integration/-/merge_requests/61
RDEPEND="${COMMON_DEPEND}
	dev-util/intltool
	kde-apps/signon-kwallet-extension:6
"
BDEPEND="sys-devel/gettext"
PDEPEND=">=kde-apps/kaccounts-providers-${PVCUT}:6"

pkg_setup() {
	MULTIBUILD_VARIANTS=( $(usev qt5) default )
}

src_configure() {
	my_src_configure() {
		if [[ ${MULTIBUILD_VARIANT} == qt5 ]]; then
			local mycmakeargs=( -DKF6_COMPAT_BUILD=ON )
		fi

		ecm_src_configure
	}

	multibuild_foreach_variant my_src_configure
}

src_compile() {
	multibuild_foreach_variant cmake_src_compile
}

src_test() {
	multibuild_foreach_variant ecm_src_test
}

src_install() {
	multibuild_foreach_variant ecm_src_install
}
