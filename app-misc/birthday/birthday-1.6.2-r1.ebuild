# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit toolchain-funcs

DESCRIPTION="Displays a list of events happening in the near future"
HOMEPAGE="https://sourceforge.net/projects/birthday/"
SRC_URI="mirror://sourceforge/birthday/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 sparc x86"

src_prepare() {
	# Don't strip, install in correct share dir and respect CFLAGS
	sed \
		-e "s@install -s@install@g" \
		-e "s@#SHARE@SHARE@g" \
		-e "s@-O2@${CFLAGS}@g" \
		-i Makefile || die
	sed \
		-e 's@grep -v@grep --binary-files=text -v@g' \
		-i runtest.sh || die

	default
}

src_compile() {
	emake CC=$(tc-getCC)
}
