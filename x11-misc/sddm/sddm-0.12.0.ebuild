# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit cmake-utils user

DESCRIPTION="Simple Desktop Display Manager"
HOMEPAGE="https://github.com/sddm/sddm"
SRC_URI="https://github.com/${PN}/${PN}/releases/download/v${PV}/${P}.tar.xz"
KEYWORDS="~amd64 ~x86"

LICENSE="GPL-2+ MIT CC-BY-3.0 CC-BY-SA-3.0 public-domain"
SLOT="0"
IUSE="consolekit +pam systemd"

RDEPEND="dev-qt/qtcore:5
	dev-qt/qtdbus:5
	dev-qt/qtgui:5
	dev-qt/qtdeclarative:5
	dev-qt/qtnetwork:5
	dev-qt/qttest:5
	>=x11-base/xorg-server-1.15.1
	x11-libs/libxcb[xkb(-)]
	consolekit? ( >=sys-auth/consolekit-0.9.4 )
	pam? ( sys-libs/pam )
	systemd? ( sys-apps/systemd:= )
	!systemd? ( || ( sys-power/upower sys-power/upower-pm-utils ) )"

DEPEND="${RDEPEND}
	dev-python/docutils
	dev-qt/linguist-tools:5
	virtual/pkgconfig"

pkg_pretend() {
	if [[ ${MERGE_TYPE} != binary  && $(tc-getCC) == *gcc* ]]; then
		if [[ $(gcc-major-version) -lt 4 || $(gcc-major-version) == 4 && $(gcc-minor-version) -lt 7 ]] ; then
			die 'The active compiler needs to be gcc 4.7 (or newer)'
		fi
	fi
}

src_prepare() {
	cmake-utils_src_prepare

	# fix for flags handling and bug 563108
	epatch "${FILESDIR}/${P}-respect-user-flags.patch" "${FILESDIR}/${P}-CVE-2015-0856.patch"
	use consolekit && epatch "${FILESDIR}/${PN}-0.11.0-consolekit.patch"
}

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_no pam PAM)
		$(cmake-utils_use_no systemd SYSTEMD)
		-DBUILD_MAN_PAGES=ON
		-DDBUS_CONFIG_FILENAME="org.freedesktop.sddm.conf"
		)

	cmake-utils_src_configure
}

pkg_postinst() {
	enewgroup ${PN}
	enewuser ${PN} -1 -1 /var/lib/${PN} ${PN} video
}
