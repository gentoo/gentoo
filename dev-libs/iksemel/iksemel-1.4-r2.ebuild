# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="eXtensible Markup Language parser library designed for Jabber applications"
HOMEPAGE="https://github.com/meduketto/iksemel"
SRC_URI="https://${PN}.googlecode.com/files/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ppc ~ppc64 ~sparc x86"
IUSE="ssl"

RDEPEND="ssl? ( net-libs/gnutls:= )"
DEPEND="${RDEPEND}"
BDEPEND="ssl? ( virtual/pkgconfig )"

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
	econf $(use_with ssl gnutls)
}

src_install() {
	default
	dodoc HACKING

	# package installs .pc files
	find "${ED}" -name '*.la' -delete || die
}
