# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

KMNAME="kde-runtime"
inherit kde4-meta flag-o-matic

DESCRIPTION="KDE Password Server"
KEYWORDS="amd64 x86"
IUSE="debug gpg"

RDEPEND="
	dev-libs/libgcrypt:0=
	gpg? ( app-crypt/gpgme[cxx] )
"
DEPEND="${RDEPEND}
	gpg? ( dev-libs/boost )
"

RESTRICT="test"
# testpamopen crashes with a buffer overflow (__fortify_fail)

PATCHES=( "${FILESDIR}/${P}-gpgmepp.patch" )

src_configure() {
	local mycmakeargs=(
		-DCMAKE_DISABLE_FIND_PACKAGE_QGpgme=ON
		$(cmake-utils_use_find_package gpg Gpgmepp)
	)

	kde4-base_src_configure
}

pkg_postinst() {
	if ! has_version "kde-plasma/kwallet-pam[oldwallet]" || ! has_version "kde-apps/kwalletmanager:4" ; then
		elog
		elog "Install kde-plasma/kwallet-pam[oldwallet] for auto-unlocking after account login."
		elog "Install kde-apps/kwalletmanager:4 to manage your kwallet."
		elog
	fi
}
