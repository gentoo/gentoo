# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

MY_P="${P/-/_}"

DESCRIPTION="Library for downloading files via HTTP using the GET method"
HOMEPAGE="https://http-fetcher.sourceforge.net"
SRC_URI="https://downloads.sourceforge.net/${PN}/${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha amd64 ppc x86"
IUSE="debug"

PATCHES=(
	"${FILESDIR}"/${PN}-1.1.0-underquoted-http-fetcher-macro.patch
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf \
		--disable-strict \
		$(use_enable debug)
}

src_install() {
	default
	dodoc -r docs/html/*.html docs/index.html README ChangeLog CREDITS INSTALL

	find "${ED}" -name '*.la' -delete || die
}
