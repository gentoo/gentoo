# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_QTHELP="false"
ECM_TEST="forceoptional"
PVCUT=$(ver_cut 1-2)
QTMIN=6.6.2
inherit ecm frameworks.kde.org optfeature xdg-utils

DESCRIPTION="Library for providing abstractions to get the developer's purposes fulfilled"

LICENSE="LGPL-2.1+"
KEYWORDS="~amd64"
IUSE="bluetooth kaccounts"

# requires running environment
RESTRICT="test"

DEPEND="
	>=dev-qt/qtbase-${QTMIN}:6[dbus,gui,network,widgets]
	>=dev-qt/qtdeclarative-${QTMIN}:6
	=kde-frameworks/kconfig-${PVCUT}*:6
	=kde-frameworks/kcoreaddons-${PVCUT}*:6
	=kde-frameworks/ki18n-${PVCUT}*:6
	=kde-frameworks/kio-${PVCUT}*:6
	=kde-frameworks/kirigami-${PVCUT}*:6
	=kde-frameworks/knotifications-${PVCUT}*:6
	=kde-frameworks/kservice-${PVCUT}*:6
	=kde-frameworks/prison-${PVCUT}*:6
	kaccounts? (
		kde-apps/kaccounts-integration:6
		>=net-libs/accounts-qt-1.16_p20220803[qt6]
	)
"
RDEPEND="${DEPEND}
	!${CATEGORY}/${PN}:5[-kf6compat(-)]
	>=kde-frameworks/kdeclarative-${PVCUT}:6
	bluetooth? ( =kde-frameworks/bluez-qt-${PVCUT}*:6 )
	kaccounts? ( >=net-libs/accounts-qml-0.7_p20231028[qt6] )
"
BDEPEND="kaccounts? ( dev-util/intltool )"

src_prepare() {
	ecm_src_prepare

	use bluetooth ||
		cmake_run_in src/plugins cmake_comment_add_subdirectory bluetooth
}

src_configure() {
	local mycmakeargs=(
		$(cmake_use_find_package kaccounts KAccounts6)
	)

	ecm_src_configure
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
