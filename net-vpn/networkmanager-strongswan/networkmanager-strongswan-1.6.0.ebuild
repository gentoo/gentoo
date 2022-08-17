# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

MY_PN="NetworkManager"
MY_P="${P/networkmanager/${MY_PN}}"

DESCRIPTION="NetworkManager StrongSwan plugin"
HOMEPAGE="https://www.strongswan.org/"
SRC_URI="https://download.strongswan.org/${MY_PN}/${MY_P}.tar.bz2"
S="${WORKDIR}/${MY_P}"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="gtk4"

RDEPEND="
	app-crypt/libsecret
	>=net-libs/libnma-1.1.0
	net-misc/networkmanager
	>=net-vpn/strongswan-5.8.3[networkmanager]
	!gtk4? ( x11-libs/gtk+:3 )
	gtk4? (
		net-libs/libnma
		gui-libs/gtk:4
	)
"

DEPEND="${RDEPEND}"

BDEPEND="
	dev-util/intltool
	virtual/pkgconfig
"

src_prepare() {
	default

	eautoreconf
}

src_configure() {
	local myeconfargs=(
		# Don't enable all warnings, as some are treated as errors and the compilation will fail
		--disable-more-warnings
		--disable-static
	)

	econf "${myeconfargs[@]}"
}

src_install() {
	default

	find "${D}" -name '*.la' -delete || die
}
