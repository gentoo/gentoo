# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools

DESCRIPTION="eXtensible Markup Language parser library designed for Jabber applications"
HOMEPAGE="https://github.com/meduketto/iksemel"
SRC_URI="https://${PN}.googlecode.com/files/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 ppc ~ppc64 x86"
IUSE="ssl static-libs"

RDEPEND="ssl? ( net-libs/gnutls:= )"
DEPEND="${RDEPEND}
	ssl? ( virtual/pkgconfig )"

PATCHES=(
	"${FILESDIR}"/${PN}-1.3-gnutls-2.8.patch
	"${FILESDIR}"/${PN}-1.4-gnutls-3.4.patch
	"${FILESDIR}"/${PN}-1.4-ikstack.patch
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf \
		$(use_with ssl gnutls) \
		$(use_enable static-libs static)
}

src_install() {
	default
	dodoc HACKING

	# package installs .pc files
	find "${D}" -name '*.la' -delete || die
}
