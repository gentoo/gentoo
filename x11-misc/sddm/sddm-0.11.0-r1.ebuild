# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit cmake-utils toolchain-funcs user

DESCRIPTION="Simple Desktop Display Manager"
HOMEPAGE="https://github.com/sddm/sddm"
SRC_URI="http://github.com/${PN}/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
KEYWORDS="~amd64 ~arm ~x86"

LICENSE="GPL-2+ MIT CC-BY-3.0 public-domain"
SLOT="0"
IUSE="consolekit systemd +upower"
REQUIRED_USE="?? ( upower systemd )"

RDEPEND="sys-libs/pam
	>=x11-base/xorg-server-1.15.1
	x11-libs/libxcb[xkb(-)]
	dev-qt/qtcore:5
	dev-qt/qtdbus:5
	dev-qt/qtdeclarative:5
	dev-qt/linguist-tools:5
	dev-qt/qttest:5
	systemd? ( sys-apps/systemd:= )
	upower? ( || ( sys-power/upower sys-power/upower-pm-utils ) )"
DEPEND="${RDEPEND}
	>=sys-devel/gcc-4.7.0
	virtual/pkgconfig"

pkg_pretend() {
	if [[ ${MERGE_TYPE} != binary ]]; then
		[[ $(gcc-version) < 4.7 ]] && \
			die 'The active compiler needs to be gcc 4.7 (or newer)'
	fi
}

src_prepare() {
	use consolekit && epatch "${FILESDIR}/${P}-consolekit.patch"
	use upower && epatch "${FILESDIR}/${PN}-0.10.0-upower.patch"
	# fix bug 552318
	epatch "${FILESDIR}/${P}-dbus-config.patch"

	# respect user's cflags
	sed -e 's|-Wall -march=native||' \
		-e 's|-O2||' \
		-i CMakeLists.txt || die 'sed failed'
}

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_no systemd SYSTEMD)
		-DDBUS_CONFIG_FILENAME:STRING="org.freedesktop.sddm.conf"
	)
	cmake-utils_src_configure
}

pkg_postinst() {
	if use consolekit; then
		ewarn "This display manager doesn't have native built-in ConsoleKit support."
		ewarn "In order to use ConsoleKit pam module with this display manager,"
		ewarn "you should remove the \"nox11\" parameter from pm_ck_connector.so"
		ewarn "line in /etc/pam.d/system-login"
	fi
	ewarn "Add the sddm user manually to the video group"
	ewarn "if you experience flickering or other rendering issues of sddm-greeter"
	ewarn "see https://github.com/gentoo/qt/pull/52"
}

pkg_setup() {
	enewgroup ${PN}
	enewuser ${PN} -1 -1 /var/lib/sddm ${PN}
}
