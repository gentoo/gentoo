# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Lightweight C Jabber library"
HOMEPAGE="https://mcabber.com"
SRC_URI="https://mcabber.com/files/${PN}/${P}.tar.bz2"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha amd64 arm ~arm64 ppc ppc64 ~riscv ~sparc x86"
IUSE="asyncns ssl openssl test"
RESTRICT="!test? ( test )"

# Automagic libidn dependency
RDEPEND=">=dev-libs/glib-2.16:2
	net-dns/libidn:=
	ssl? (
		!openssl? ( >=net-libs/gnutls-1.4.0:0= )
		openssl? ( dev-libs/openssl:0= )
	)
	asyncns? ( >=net-libs/libasyncns-0.3 )"
DEPEND="${RDEPEND}
	test? ( dev-libs/check )"
BDEPEND="dev-util/glib-utils
	virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${PN}-1.5.4-freeaddrinfo-musl.patch
)

src_configure() {
	local myconf

	if use ssl; then
		if ! use openssl; then
			myconf="${myconf} --with-ssl=gnutls"
		else
			myconf="${myconf} --with-ssl=openssl"
		fi
	else
		myconf="${myconf} --with-ssl=no"
	fi

	# --with-compile-warnings=yes to avoid default =error
	econf \
		$(use_with asyncns) \
		--with-compile-warnings=yes \
		${myconf}
}

src_install() {
	default

	find "${ED}" -name '*.la' -delete || die
}
