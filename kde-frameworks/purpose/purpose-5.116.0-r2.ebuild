# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_QTHELP="false"
ECM_TEST="forceoptional"
PVCUT=$(ver_cut 1-2)
QTMIN=5.15.9
inherit ecm frameworks.kde.org optfeature xdg-utils

DESCRIPTION="Library for providing abstractions to get the developer's purposes fulfilled"

LICENSE="LGPL-2.1+"
KEYWORDS="amd64 ~arm arm64 ~loong ~ppc64 ~riscv x86"
IUSE="bluetooth kaccounts"

# requires running environment
RESTRICT="test"

DEPEND="
	>=dev-qt/qtdbus-${QTMIN}:5
	>=dev-qt/qtdeclarative-${QTMIN}:5
	>=dev-qt/qtgui-${QTMIN}:5
	>=dev-qt/qtnetwork-${QTMIN}:5
	>=dev-qt/qtwidgets-${QTMIN}:5
	=kde-frameworks/kconfig-${PVCUT}*:5
	=kde-frameworks/kcoreaddons-${PVCUT}*:5
	=kde-frameworks/ki18n-${PVCUT}*:5
	=kde-frameworks/kio-${PVCUT}*:5
	=kde-frameworks/kirigami-${PVCUT}*:5
	=kde-frameworks/knotifications-${PVCUT}*:5
	=kde-frameworks/kservice-${PVCUT}*:5
	=kde-frameworks/prison-${PVCUT}*:5
	kaccounts? (
		|| (
			kde-apps/kaccounts-integration:6[qt5]
			kde-apps/kaccounts-integration:5
		)
		>=net-libs/accounts-qt-1.16_p20220803[qt5(-)]
	)
"
RDEPEND="${DEPEND}
	>=dev-qt/qtquickcontrols-${QTMIN}:5
	>=dev-qt/qtquickcontrols2-${QTMIN}:5
	>=kde-frameworks/kdeclarative-${PVCUT}:5
	bluetooth? ( =kde-frameworks/bluez-qt-${PVCUT}*:5 )
	kaccounts? (
		kde-frameworks/purpose-kaccounts-services
		>=net-libs/accounts-qml-0.7_p20231028[qt5(-)]
	)
"
BDEPEND="kaccounts? ( dev-util/intltool )"

src_prepare() {
	ecm_src_prepare

	use bluetooth ||
		cmake_run_in src/plugins cmake_comment_add_subdirectory bluetooth
}

src_configure() {
	local mycmakeargs=(
		$(cmake_use_find_package kaccounts KAccounts)
	)
	ecm_src_configure
}

src_install() {
	# Shipped by kde-frameworks/purpose-kaccounts-services package for shared use w/ SLOT 5
	use kaccounts && ECM_REMOVE_FROM_INSTALL=(
		/usr/share/accounts/services/kde/{google-youtube,nextcloud-upload}.service
	)
	ecm_src_install
}

pkg_postinst() {
	if [[ -z "${REPLACING_VERSIONS}" ]]; then
		optfeature "Send through KDE Connect" kde-misc/kdeconnect
	fi
	ecm_pkg_postinst
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_icon_cache_update
}
