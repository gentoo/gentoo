# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit toolchain-funcs

DESCRIPTION="An IRC and ICB client that runs under most UNIX platforms"
SRC_URI="https://ircii.warped.com/${P}.tar.bz2
	https://ircii.warped.com/old/${P}.tar.bz2"
HOMEPAGE="http://eterna.com.au/ircii/"

SLOT="0"
LICENSE="BSD"
KEYWORDS="amd64 ~ppc x86 ~amd64-linux ~x86-linux ~ppc-macos ~sparc-solaris ~x86-solaris"
IUSE="ipv6"

DEPEND="sys-libs/ncurses:0=
	virtual/libiconv"
# This and irc-client both install /usr/bin/irc #247987
RDEPEND="${DEPEND}
	!net-irc/irc-client"

PATCHES=( "${FILESDIR}/${PN}-manpage-path.patch" )

src_configure() {
	tc-export CC
	econf $(use_enable ipv6)
}

src_install() {
	emake -j1 DESTDIR="${D}" install

	dodoc ChangeLog INSTALL NEWS README \
		doc/Copyright doc/crypto doc/VERSIONS doc/ctcp
}
