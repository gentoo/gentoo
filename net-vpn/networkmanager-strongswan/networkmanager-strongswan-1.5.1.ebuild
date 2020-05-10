# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

MY_PN="NetworkManager"
MY_P="${P/networkmanager/${MY_PN}}"

DESCRIPTION="NetworkManager StrongSwan plugin"
HOMEPAGE="https://www.strongswan.org/"
SRC_URI="https://download.strongswan.org/${MY_PN}/${MY_P}.tar.bz2"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	app-crypt/libsecret
	>=net-libs/libnma-1.1.0
	net-misc/networkmanager
	>=net-vpn/strongswan-5.8.3[networkmanager]
	x11-libs/gtk+:3
"

DEPEND="${RDEPEND}"

BDEPEND="
	dev-util/intltool
	virtual/pkgconfig
"

S="${WORKDIR}/${MY_P}"

PATCHES="${FILESDIR}/${P}-change-appdata-location.patch"

src_prepare() {
	default

	eautoreconf
}

src_configure() {
	local myeconfargs=(
		# Don't enable all warnings, as some are treated as errors and the compilation will fail
		--disable-more-warnings
		--disable-static
		--without-libnm-glib
	)

	econf "${myeconfargs[@]}"
}

src_install() {
	default

	find "${D}" -name '*.la' -delete || die
}
