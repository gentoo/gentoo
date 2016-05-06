# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit cmake-utils user

DESCRIPTION="Simple Desktop Display Manager"
HOMEPAGE="https://github.com/sddm/sddm"
SRC_URI="https://github.com/${PN}/${PN}/releases/download/v${PV}/${P}.tar.xz"
KEYWORDS="~amd64 ~arm ~x86"

LICENSE="GPL-2+ MIT CC-BY-3.0 CC-BY-SA-3.0 public-domain"
SLOT="0"
IUSE="consolekit +pam systemd"

RDEPEND="dev-qt/qtcore:5
	dev-qt/qtdbus:5
	dev-qt/qtgui:5
	dev-qt/qtdeclarative:5
	dev-qt/qtnetwork:5
	>=x11-base/xorg-server-1.15.1
	x11-libs/libxcb[xkb(-)]
	consolekit? ( >=sys-auth/consolekit-0.9.4 )
	pam? ( sys-libs/pam )
	systemd? ( sys-apps/systemd:= )
	!systemd? ( || ( sys-power/upower sys-power/upower-pm-utils ) )"

DEPEND="${RDEPEND}
	dev-python/docutils
	dev-qt/linguist-tools:5
	dev-qt/qttest:5
	virtual/pkgconfig"

pkg_pretend() {
	if [[ ${MERGE_TYPE} != binary  && $(tc-getCC) == *gcc* ]]; then
		if [[ $(gcc-major-version) -lt 4 || $(gcc-major-version) == 4 && $(gcc-minor-version) -lt 7 ]] ; then
			die 'The active compiler needs to be gcc 4.7 (or newer)'
		fi
	fi
}

src_prepare() {
	eapply "${FILESDIR}/${PN}-0.13.0-pam_kwallet.patch"
	# fix for flags handling and bug 563108
	eapply "${FILESDIR}/${PN}-0.12.0-respect-user-flags.patch"
	eapply "${FILESDIR}/${P}-password-focus.patch"
	use consolekit && eapply "${FILESDIR}/${PN}-0.11.0-consolekit.patch"

	cmake-utils_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DENABLE_PAM=$(usex pam)
		-DNO_SYSTEMD=$(usex '!systemd')
		-DBUILD_MAN_PAGES=ON
		-DDBUS_CONFIG_FILENAME="org.freedesktop.sddm.conf"
		)

	cmake-utils_src_configure
}

pkg_postinst() {
	enewgroup ${PN}
	enewuser ${PN} -1 -1 /var/lib/${PN} ${PN} video

	if use consolekit && use pam && [[ -e "${ROOT}"/etc/pam.d/system-login ]]; then
		local line=$(grep "pam_ck_connector.*nox11" "${ROOT}"/etc/pam.d/system-login)
		if [[ -z ${line} ]]; then
			ewarn
			ewarn "Erroneous /etc/pam.d/system-login settings detected!"
			ewarn "Please restore 'nox11' option in the line containing pam_ck_connector:"
			ewarn
			ewarn "session      optional      pam_ck_connector.so nox11"
			ewarn
			ewarn "or 'emerge -1 sys-auth/pambase' and run etc-update."
			ewarn
		fi
	fi
}
