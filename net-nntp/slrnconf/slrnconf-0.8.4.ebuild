# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

DESCRIPTION="slrnconf is a graphical configuration utility for the newsreader slrn"
HOMEPAGE="http://home.arcor.de/kaffeetisch/slrnconf.html"
SRC_URI="http://home.arcor.de/kaffeetisch/downloads/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc x86"
IUSE=""

RDEPEND="dev-lang/perl
	dev-perl/Gtk2
	dev-perl/Parse-RecDescent
	net-nntp/slrn"
DEPEND="${RDEPEND}
	>=sys-apps/sed-4"

src_unpack() {
	unpack ${A}

	sed -i -e 's/^install: all$/install:/' ${S}/Makefile
}

src_compile() {
	make PREFIX=/usr || die "make failed"
}

src_install() {
	make PREFIX=${D}/usr install || die "make install failed"
}
