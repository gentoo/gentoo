# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit kde5

DESCRIPTION="Framework providing desktop-wide storage for passwords"
LICENSE="LGPL-2+"
KEYWORDS="~amd64 ~x86"
IUSE="gpg"

RDEPEND="
	$(add_frameworks_dep kconfig)
	$(add_frameworks_dep kcoreaddons)
	$(add_frameworks_dep kdbusaddons)
	$(add_frameworks_dep ki18n)
	$(add_frameworks_dep kiconthemes)
	$(add_frameworks_dep knotifications)
	$(add_frameworks_dep kservice)
	$(add_frameworks_dep kwidgetsaddons)
	$(add_frameworks_dep kwindowsystem)
	dev-libs/libgcrypt:0=
	dev-qt/qtdbus:5
	dev-qt/qtgui:5
	dev-qt/qtwidgets:5
	gpg? (
		$(add_kdeapps_dep gpgmepp)
		app-crypt/gpgme
	)
"
DEPEND="${RDEPEND}"

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_find_package gpg Gpgme)
		$(cmake-utils_use_find_package gpg Gpgmepp)
	)
	kde5_src_configure
}
