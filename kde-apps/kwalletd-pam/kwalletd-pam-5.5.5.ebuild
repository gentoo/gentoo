# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

MY_PN="kwallet-pam"
inherit cmake-utils multilib

DESCRIPTION="KWallet PAM module to not enter password again"
HOMEPAGE="https://www.kde.org/"
SRC_URI="mirror://kde/stable/plasma/${PV}/${MY_PN}-${PV}.tar.xz"

LICENSE="LGPL-2.1"
SLOT="4"
KEYWORDS="amd64 ~x86"
IUSE=""

DEPEND="
	dev-libs/libgcrypt:0=
	virtual/pam
"
RDEPEND="${DEPEND}
	net-misc/socat
"

S="${WORKDIR}/${MY_PN}-${PV}"

PATCHES=( "${FILESDIR}/${PN}-5.5.4-coverity.patch" )

src_configure() {
	local mycmakeargs=(
		-DCMAKE_INSTALL_LIBDIR="/$(get_libdir)"
		-DKWALLET4=1
	)

	cmake-utils_src_configure
}

pkg_postinst() {
	check_dm() {
		if [[ -e "${ROOT}${2}" ]] && \
			grep -Eq "auth\s+optional\s+pam_kwallet.so" "${ROOT}${2}" && \
			grep -Eq "session\s+optional\s+pam_kwallet.so" "${ROOT}${2}" ; then
			elog "    ${1} - ${2} ...GOOD"
		else
			ewarn "    ${1} - ${2} ...BAD"
		fi
	}
	elog
	elog "This package enables auto-unlocking of kde-apps/kwalletd:4."
	elog "List of things to make it work:"
	elog "1.  Use standard blowfish encryption instead of GPG"
	elog "2.  Use same password for login and kwallet"
	elog "3.  A display manager with support for PAM"
	elog "4.a Have the following lines in the display manager's pam.d file:"
	elog "    -auth        optional        pam_kwallet.so kdehome=.kde4"
	elog "    -session     optional        pam_kwallet.so"
	elog "4.b Checking installed DMs..."
	has_version "x11-misc/sddm" && check_dm "SDDM" "/etc/pam.d/sddm"
	has_version "x11-misc/lightdm" && check_dm "LightDM" "/etc/pam.d/lightdm"
	has_version "kde-base/kdm" && check_dm "KDM" "/etc/pam.d/kde"
	elog
}
