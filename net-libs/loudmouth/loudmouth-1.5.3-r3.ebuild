# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Lightweight C Jabber library"
HOMEPAGE="https://mcabber.com"
SRC_URI="https://mcabber.com/files/${PN}/${P}.tar.bz2"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="alpha amd64 arm ia64 ppc ppc64 sparc x86 ~ppc-macos"

IUSE="asyncns ssl openssl static-libs test"
RESTRICT="!test? ( test )"

# Automagic libidn dependency
RDEPEND="
	>=dev-libs/glib-2.16:2
	net-dns/libidn:=
	ssl? (
		!openssl? ( >=net-libs/gnutls-1.4.0:0= )
		openssl? ( dev-libs/openssl:0= )
	)
	asyncns? ( >=net-libs/libasyncns-0.3 )
"
DEPEND="${RDEPEND}
	dev-util/glib-utils
	dev-util/gtk-doc-am
	test? ( dev-libs/check )
	virtual/pkgconfig
"

PATCHES=(
	"${FILESDIR}"/${P}-gcc7.patch
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

	econf \
		$(use_enable static-libs static) \
		$(use_with asyncns) \
		${myconf}
}
