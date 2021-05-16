# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="Ninja IRC Client"
HOMEPAGE="https://wiki.gentoo.org/wiki/No_homepage"
SRC_URI="ftp://qoop.org/ninja/stable/${P/_/}.tar.gz"
S="${WORKDIR}"/${P/_*/}

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="amd64 ppc ~ppc64 ~sparc x86"
IUSE="ncurses ipv6 ssl"

RESTRICT="test"

DEPEND="
	ncurses? ( sys-libs/ncurses:= )
	ssl?  ( dev-libs/openssl:= )
"
RDEPEND="${DEPEND}"

MAKEOPTS="${MAKEOPTS} -j1"

src_configure() {
	tc-export CC

	econf $(use_enable ipv6)

	# Generated post-configure
	sed -i -e "s:/usr/lib:/usr/$(get_libdir):" Makefile || die
}

src_install() {
	default

	# bug #436804
	mv "${ED}"/usr/bin/ninja{,_irc} || die
}
