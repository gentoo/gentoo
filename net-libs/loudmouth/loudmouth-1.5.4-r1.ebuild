# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Lightweight & easy-to-use Jabber library written in C"
HOMEPAGE="https://mcabber.com"
SRC_URI="https://mcabber.com/files/${PN}/${P}.tar.bz2"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha amd64 arm ~arm64 ppc ppc64 ~riscv sparc x86 ~ppc-macos"
IUSE="asyncns debug +gnutls idn +ssl"

RDEPEND="
	>=dev-libs/glib-2.38
	asyncns? ( >=net-libs/libasyncns-0.3 )
	idn? ( net-dns/libidn:= )
	ssl? (
		gnutls? ( >=net-libs/gnutls-3.0.20:= )
		!gnutls? ( dev-libs/openssl:= )
	)
"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-util/glib-utils
	virtual/pkgconfig
"

PATCHES=( "${FILESDIR}"/${PN}-1.5.4-freeaddrinfo-musl.patch )

src_configure() {
	local SSL=no
	use ssl && SSL=$(usex gnutls gnutls openssl)

	local myeconfargs=(
		--with-compile-warnings=yes # avoid default =error
		--with-ssl=${SSL}
		$(use_enable debug)
		$(use_with asyncns)
		$(use_with idn)
	)

	econf "${myeconfargs[@]}"
}

src_install() {
	default

	find "${ED}" -type f -name '*.la' -delete || die
}
