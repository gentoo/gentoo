# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit flag-o-matic toolchain-funcs

MY_P="ScrollZ-${PV}"

DESCRIPTION="Advanced IRC client based on ircII"
HOMEPAGE="https://www.scrollz.info/"
SRC_URI="https://www.scrollz.info/download/${MY_P}.tar.gz"
SRC_URI+=" https://dev.gentoo.org/~sam/distfiles/${CATEGORY}/${PN}/${P}-patches.tar.xz"
S="${WORKDIR}/${MY_P}"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ppc ~riscv x86 ~amd64-linux ~x86-linux ~ppc-macos"
IUSE="gmp gnutls ipv6 ssl"
REQUIRED_USE="gnutls? ( ssl )"

BDEPEND="virtual/pkgconfig"
DEPEND="
	sys-libs/ncurses:=
	virtual/libcrypt:=
	gmp? ( dev-libs/gmp:= )
	ssl? (
		gnutls? ( net-libs/gnutls:= )
		!gnutls? ( dev-libs/openssl:= )
	)
"
RDEPEND="${DEPEND}"

PATCHES=(
	# https://github.com/ScrollZ/ScrollZ/pull/30
	"${WORKDIR}"/${P}-patches
)

src_configure() {
	# Many -Wdeprecated-non-prototype warnings
	append-cflags -std=gnu89

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
		$(use_enable ipv6) \
		--enable-regexp \
		$(use_enable gmp fish) \
		${_myssl}
}

src_install() {
	emake \
		DESTDIR="${ED}" \
		mandir="${EPREFIX}/usr/share/man/man1" \
		install

	dodoc ChangeLog* NEWS README* todo
}
