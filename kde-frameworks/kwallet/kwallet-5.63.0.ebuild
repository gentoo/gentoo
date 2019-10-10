# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit kde5

DESCRIPTION="Framework providing desktop-wide storage for passwords"
LICENSE="LGPL-2+"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"
IUSE="gpg +man"

BDEPEND="
	man? ( $(add_frameworks_dep kdoctools) )
"
DEPEND="
	$(add_frameworks_dep kconfig)
	$(add_frameworks_dep kconfigwidgets)
	$(add_frameworks_dep kcoreaddons)
	$(add_frameworks_dep kdbusaddons)
	$(add_frameworks_dep ki18n)
	$(add_frameworks_dep knotifications)
	$(add_frameworks_dep kservice)
	$(add_frameworks_dep kwidgetsaddons)
	$(add_frameworks_dep kwindowsystem)
	$(add_qt_dep qtdbus)
	$(add_qt_dep qtgui)
	$(add_qt_dep qtwidgets)
	dev-libs/libgcrypt:0=
	gpg? ( >=app-crypt/gpgme-1.7.1[cxx,qt5] )
"
RDEPEND="${DEPEND}"

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_find_package gpg Gpgmepp)
		$(cmake-utils_use_find_package man KF5DocTools)
	)

	kde5_src_configure
}

pkg_postinst() {
	if ! has_version "kde-plasma/kwallet-pam" || ! has_version "kde-apps/kwalletmanager:5" ; then
		elog
		elog "Install kde-plasma/kwallet-pam for auto-unlocking after account login."
		elog "Install kde-apps/kwalletmanager:5 to manage your kwallet."
		elog
	fi
	elog "For more information, read https://wiki.gentoo.org/wiki/KDE#KWallet"
}
