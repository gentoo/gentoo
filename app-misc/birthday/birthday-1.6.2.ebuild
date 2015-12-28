# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit toolchain-funcs

DESCRIPTION="Displays a list of events happening in the near future"
HOMEPAGE="http://sourceforge.net/projects/birthday/"
SRC_URI="mirror://sourceforge/birthday/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 sparc x86"
IUSE=""

src_unpack() {
	unpack ${A}
	cd "${S}"

	# Don't strip, install in correct share dir and respect CFLAGS
	sed \
		-e "s:install -s:install:g" -e "s:#SHARE:SHARE:g" -e "s:-O2:${CFLAGS}:g" \
		-i Makefile || die
	sed \
		-e 's:grep -v:grep --binary-files=text -v:g' \
		-i runtest.sh || die
}

src_compile() {
	emake CC=$(tc-getCC) || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
}
