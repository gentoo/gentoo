# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PN="NetworkManager"
MY_P="${P/networkmanager/${MY_PN}}"

DESCRIPTION="NetworkManager StrongSwan plugin"
HOMEPAGE="https://www.strongswan.org/"
SRC_URI="https://download.strongswan.org/${MY_PN}/${MY_P}.tar.bz2"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE="+glib"

RDEPEND="
	app-crypt/libsecret
	gnome-extra/nm-applet
	net-misc/networkmanager
	net-vpn/strongswan[networkmanager]
	x11-libs/gtk+:3
"

DEPEND="
	${RDEPEND}
	dev-util/intltool
"

BDEPEND="virtual/pkgconfig"

S="${WORKDIR}/${MY_P}"

src_configure() {
	local myeconfargs=(
		# Don't	enable all warnings, as	some are treated as errors and the compilation will fail
		--disable-more-warnings
		--disable-static
		$(usex glib '' --without-libnm-glib)
	)

	econf "${myeconfargs[@]}"
}

src_install() {
	default

	find "${D}" -name '*.la' -delete || die
}
