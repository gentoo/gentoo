# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="An IRC and ICB client that runs under most UNIX platforms"
SRC_URI="https://ircii.warped.com/${P}.tar.bz2
	https://ircii.warped.com/old/${P}.tar.bz2"
HOMEPAGE="http://eterna.com.au/ircii/"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~ppc ~riscv x86 ~amd64-linux ~x86-linux ~ppc-macos ~sparc-solaris ~x86-solaris"

DEPEND="dev-libs/openssl:0=
	sys-libs/ncurses:0=
	virtual/libcrypt:=
	virtual/libiconv"
RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}/${PN}-manpage-path.patch" )

src_configure() {
	tc-export CC
	default
}

src_install() {
	# Still needed as of 20210314, otherwise man dirs don't exist at the right time
	emake -j1 DESTDIR="${D}" install

	dodoc ChangeLog INSTALL NEWS README \
		doc/Copyright doc/crypto doc/VERSIONS doc/ctcp
}
