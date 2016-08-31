# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

KDE_AUTODEPS="false"
inherit kde5 multibuild multilib

DESCRIPTION="KWallet PAM module to not enter password again"
LICENSE="LGPL-2.1"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="+oldwallet"

COMMON_DEPEND="
	dev-libs/libgcrypt:0=
	virtual/pam
"
DEPEND="${COMMON_DEPEND}
	$(add_frameworks_dep extra-cmake-modules)
	$(add_qt_dep qtcore)
"
RDEPEND="${COMMON_DEPEND}
	!kde-apps/kwalletd-pam
	net-misc/socat
"

pkg_setup() {
	kde5_pkg_setup
	MULTIBUILD_VARIANTS=( kf5 $(usev oldwallet) )
}

src_configure() {
	myconfigure() {
		local mycmakeargs=(
			-DCMAKE_INSTALL_LIBDIR="/$(get_libdir)"
		)
		[[ ${MULTIBUILD_VARIANT} = oldwallet ]] && mycmakeargs+=( -DKWALLET4=1 )

		kde5_src_configure
	}
	multibuild_foreach_variant myconfigure
}

src_compile() {
	multibuild_foreach_variant kde5_src_compile
}

src_test() {
	multibuild_foreach_variant kde5_src_test
}

src_install() {
	multibuild_foreach_variant kde5_src_install
}

pkg_postinst() {
	check_dm() {
		local good
		if [[ -e "${ROOT}${2}" ]] ; then
			if grep -Eq "auth\s+optional\s+pam_kwallet5.so" "${ROOT}${2}" && \
				grep -Eq "session\s+optional\s+pam_kwallet5.so" "${ROOT}${2}" ; then
				good=true
			fi
			if use oldwallet ; then
				if ! grep -Eq "auth\s+optional\s+pam_kwallet.so" "${ROOT}${2}" || \
					! grep -Eq "session\s+optional\s+pam_kwallet.so" "${ROOT}${2}" ; then
					good=false
				fi
			fi
		fi
		[[ "${good}" = true ]] && \
			elog "    ${1} - ${2} ...GOOD" || \
			ewarn "    ${1} - ${2} ...BAD"
	}
	elog
	elog "This package enables auto-unlocking of kde-frameworks/kwallet:5."
	use oldwallet && elog "You have also selected support for legacy kde-apps/kwalletd:4."
	elog "List of things to make it work:"
	elog "1.  Use standard blowfish encryption instead of GPG"
	elog "2.  Use same password for login and kwallet"
	elog "3.  A display manager with support for PAM"
	elog "4.a Have the following lines in the display manager's pam.d file:"
	elog "    -auth        optional        pam_kwallet5.so"
	elog "    -session     optional        pam_kwallet5.so auto_start"
	if use oldwallet ; then
		elog "    -auth        optional        pam_kwallet.so kdehome=.kde4"
		elog "    -session     optional        pam_kwallet.so"
	fi
	elog "4.b Checking installed DMs..."
	has_version "x11-misc/sddm" && check_dm "SDDM" "/etc/pam.d/sddm"
	has_version "x11-misc/lightdm" && check_dm "LightDM" "/etc/pam.d/lightdm"
	has_version "kde-base/kdm" && check_dm "KDM" "/etc/pam.d/kde"
	elog
}
