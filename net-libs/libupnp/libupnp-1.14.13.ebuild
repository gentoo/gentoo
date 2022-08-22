# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

MY_PN="pupnp"

DESCRIPTION="An Portable Open Source UPnP Development Kit"
HOMEPAGE="http://pupnp.sourceforge.net/"
SRC_URI="https://github.com/${MY_PN}/${MY_PN}/archive/release-${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${MY_PN}-release-${PV}"

LICENSE="BSD"
SLOT="0/17"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~ppc ~ppc64 ~riscv ~sparc ~x86 ~amd64-linux"
IUSE="blocking-tcp debug doc +ipv6 +reuseaddr samples +ssl static-libs"

RDEPEND="ssl? ( dev-libs/openssl:0= )"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=( "${FILESDIR}/${PN}-1.14.12-disable-network-tests.patch" )

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	local myeconfargs=(
		$(use_enable blocking-tcp blocking-tcp-connections)
		$(use_enable debug)
		$(use_enable ipv6)
		$(use_enable reuseaddr)
		$(use_enable samples)
		$(use_enable ssl open_ssl)
		$(use_enable static-libs static)
	)

	econf ${myeconfargs[@]}
}

src_install() {
	default

	find "${D}" -name '*.la' -delete || die
}
