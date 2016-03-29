# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

KDE_AUTODEPS="false"
inherit kde5 multilib

DESCRIPTION="KWallet PAM module to not enter password again"
LICENSE="LGPL-2.1"
KEYWORDS="~amd64 ~arm ~x86"
IUSE=""

COMMON_DEPEND="
	dev-libs/libgcrypt:0=
	virtual/pam
"
DEPEND="${COMMON_DEPEND}
	$(add_frameworks_dep extra-cmake-modules)
"
RDEPEND="${COMMON_DEPEND}
	net-misc/socat
"

src_configure() {
	local mycmakeargs=(
		-DCMAKE_INSTALL_LIBDIR="/$(get_libdir)"
	)

	kde5_src_configure
}

pkg_postinst() {
	check_dm() {
		if [[ -e "${ROOT}${2}" ]] && \
			[[ -n $(egrep "auth\s+optional\s+pam_kwallet5.so" "${ROOT}${2}") ]] && \
			[[ -n $(egrep "session\s+optional\s+pam_kwallet5.so" "${ROOT}${2}") ]]; then
			elog "    ${1} - ${2} ...GOOD"
		else
			ewarn "    ${1} - ${2} ...BAD"
		fi
	}
	elog
	elog "This package enables auto-unlocking of kde-frameworks/kwallet:5."
	elog "List of things to make it work:"
	elog "1.  Use same password for login and kwallet"
	elog "2.  A display manager with support for PAM"
	elog "3.a Have the following lines in the display manager's pam.d file:"
	elog "    -auth        optional        pam_kwallet5.so"
	elog "    -session     optional        pam_kwallet5.so auto_start"
	elog "3.b Checking installed DMs..."
	has_version "x11-misc/sddm" && check_dm "SDDM" "/etc/pam.d/sddm"
	has_version "x11-misc/lightdm" && check_dm "LightDM" "/etc/pam.d/lightdm"
	has_version "kde-base/kdm" && check_dm "KDM" "/etc/pam.d/kde"
	elog
}
