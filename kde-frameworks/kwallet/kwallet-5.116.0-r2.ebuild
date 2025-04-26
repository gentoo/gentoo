# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PVCUT=$(ver_cut 1-2)
QTMIN=5.15.9
inherit ecm frameworks.kde.org optfeature

DESCRIPTION="Framework providing desktop-wide storage for passwords"

LICENSE="LGPL-2+"
KEYWORDS="amd64 arm64 ~loong ppc64 ~riscv ~x86"
IUSE="+man"

DEPEND="
	>=app-crypt/qca-2.3.9:2[qt5(-)]
	dev-libs/libgcrypt:0=
	>=dev-qt/qtdbus-${QTMIN}:5
	>=dev-qt/qtgui-${QTMIN}:5
	>=dev-qt/qtwidgets-${QTMIN}:5
	=kde-frameworks/kconfig-${PVCUT}*:5
	=kde-frameworks/kconfigwidgets-${PVCUT}*:5
	=kde-frameworks/kcoreaddons-${PVCUT}*:5
	=kde-frameworks/kdbusaddons-${PVCUT}*:5
	=kde-frameworks/ki18n-${PVCUT}*:5
	=kde-frameworks/knotifications-${PVCUT}*:5
	=kde-frameworks/kservice-${PVCUT}*:5
	=kde-frameworks/kwidgetsaddons-${PVCUT}*:5
	=kde-frameworks/kwindowsystem-${PVCUT}*:5[X]
"
RDEPEND="${DEPEND}
	kde-frameworks/kwallet:6
"
BDEPEND="man? ( >=kde-frameworks/kdoctools-${PVCUT}:5 )"

src_configure() {
	local mycmakeargs=(
		-DBUILD_KWALLETD=OFF
		-DBUILD_KWALLET_QUERY=OFF
		$(cmake_use_find_package man KF5DocTools)
	)
	ecm_src_configure
}

pkg_postinst() {
	if [[ -z "${REPLACING_VERSIONS}" ]]; then
		optfeature "Auto-unlocking after Plasma login" "kde-plasma/kwallet-pam"
		optfeature "KWallet management" "kde-apps/kwalletmanager"
		elog "For more information, read https://wiki.gentoo.org/wiki/KDE#KWallet"
	fi
	ecm_pkg_postinst
}
