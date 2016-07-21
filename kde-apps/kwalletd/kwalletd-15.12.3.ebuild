# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

KMNAME="kde-runtime"
inherit kde4-meta

DESCRIPTION="KDE Password Server"
KEYWORDS="amd64 ~arm x86"
IUSE="debug gpg"

DEPEND="
	dev-libs/libgcrypt:0=
	gpg? (
		app-crypt/gpgme
		|| ( $(add_kdeapps_dep gpgmepp) $(add_kdeapps_dep kdepimlibs) )
	)
"
RDEPEND="${DEPEND}"

RESTRICT="test"
# testpamopen crashes with a buffer overflow (__fortify_fail)

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_find_package gpg Gpgme)
		$(cmake-utils_use_find_package gpg QGpgme)
	)

	kde4-base_src_configure
}

pkg_postinst() {
	if ! has_version "kde-apps/kwalletd-pam" || ! has_version "kde-apps/kwalletmanager:4" ; then
		elog
		elog "Install kde-apps/kwalletd-pam for auto-unlocking after account login."
		elog "Install kde-apps/kwalletmanager:4 to manage your kwallet."
		elog
	fi
}
