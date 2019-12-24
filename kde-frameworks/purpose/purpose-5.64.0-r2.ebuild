# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

ECM_QTHELP="false"
ECM_TEST="forceoptional"
PVCUT=$(ver_cut 1-2)
QTMIN=5.12.3
inherit ecm kde.org

DESCRIPTION="Library for providing abstractions to get the developer's purposes fulfilled"
LICENSE="LGPL-2.1+"
KEYWORDS="amd64 ~arm arm64 ~x86"
IUSE="+dolphin +kaccounts"

DEPEND="
	>=dev-qt/qtdeclarative-${QTMIN}:5
	>=dev-qt/qtgui-${QTMIN}:5
	>=dev-qt/qtnetwork-${QTMIN}:5
	>=dev-qt/qtwidgets-${QTMIN}:5
	>=kde-frameworks/kcoreaddons-${PVCUT}:5
	>=kde-frameworks/ki18n-${PVCUT}:5
	>=kde-frameworks/kio-${PVCUT}:5
	>=kde-frameworks/kirigami-${PVCUT}:5
	dolphin? ( >=kde-frameworks/knotifications-${PVCUT}:5 )
	kaccounts? (
		>=kde-apps/kaccounts-integration-19.04.3:5
		net-libs/accounts-qt
	)
"
RDEPEND="${DEPEND}
	>=dev-qt/qtquickcontrols-${QTMIN}:5
	>=dev-qt/qtquickcontrols2-${QTMIN}:5
	>=kde-frameworks/kdeclarative-${PVCUT}:5
	kaccounts? ( net-libs/accounts-qml )
"

# requires running environment
RESTRICT+=" test"

PATCHES=( "${FILESDIR}/${PN}-5.64.0-ecmqmlmodules.patch" ) # git master

src_configure() {
	local mycmakeargs=(
		$(cmake_use_find_package dolphin KF5Notifications)
		$(cmake_use_find_package kaccounts KAccounts)
	)

	ecm_src_configure
}

pkg_postinst(){
	ecm_pkg_postinst

	if ! has_version "kde-misc/kdeconnect[app]" ; then
		elog "Optional runtime dependency:"
		elog "kde-misc/kdeconnect[app] (send through KDE Connect)"
	fi
}
