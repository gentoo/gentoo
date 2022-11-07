# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="RFC3261 compliant SIP User-Agent library"
HOMEPAGE="https://github.com/freeswitch/sofia-sip"
SRC_URI="https://github.com/freeswitch/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2.1+ BSD public-domain" # See COPYRIGHT
SLOT="0"
KEYWORDS="~alpha amd64 ~arm arm64 ~ia64 ppc ~ppc64 sparc ~x86 ~x86-linux"
IUSE="ssl test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-libs/glib:2
	ssl? (
		dev-libs/openssl:0=
	)"
DEPEND="${RDEPEND}
	test? ( dev-libs/check )"
BDEPEND="virtual/pkgconfig"

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf \
		--disable-static \
		$(use_with ssl openssl)
}

src_install() {
	default
	dodoc RELEASE

	# no static archives
	find "${D}" -name '*.la' -delete || die
}
