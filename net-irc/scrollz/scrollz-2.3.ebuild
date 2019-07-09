# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit toolchain-funcs

MY_P="ScrollZ-${PV}"

DESCRIPTION="Advanced IRC client based on ircII"
HOMEPAGE="http://www.scrollz.info/"
SRC_URI="http://www.scrollz.info/download/${MY_P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ppc x86 ~amd64-linux ~x86-linux ~ppc-macos"

IUSE="gmp gnutls ipv6 socks5 ssl"
REQUIRED_USE="gnutls? ( ssl )"

RDEPEND="
	sys-libs/ncurses:0=
	gmp? ( dev-libs/gmp:0= )
	ssl? (
		gnutls? ( net-libs/gnutls:0= )
		!gnutls? ( dev-libs/openssl:0= )
		)
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
"

S="${WORKDIR}/ScrollZ-${MY_P}"

src_configure() {
	local _myssl

	if use ssl; then
		if use gnutls; then
			_myssl="--with-ssl"
		else
			_myssl="--with-openssl"
		fi
	fi

	tc-export CC #397441, ancient autoconf
	econf \
		--with-default-server="irc.gentoo.org" \
		$(use_with socks5) \
		$(use_enable ipv6) \
		--enable-regexp \
		$(use_enable gmp fish) \
		${_myssl}
}

src_install() {
	emake \
		DESTDIR="${D}" \
		mandir="${EPREFIX}/usr/share/man/man1" \
		install

	dodoc ChangeLog* NEWS README* todo
}
