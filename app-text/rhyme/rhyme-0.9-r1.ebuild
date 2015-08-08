# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="2"

inherit toolchain-funcs

# missing files ...
RESTRICT="test"

DESCRIPTION="Console based Rhyming Dictionary"
HOMEPAGE="http://rhyme.sourceforge.net/"
SRC_URI="mirror://sourceforge/rhyme/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND=">=sys-libs/readline-4.3
	>=sys-libs/gdbm-1.8.0"
RDEPEND="${DEPEND}"

src_prepare() {
	# termcap is used by default, switch to ncurses
	sed -i Makefile \
		-e 's|-ltermcap||g' \
		-e 's|-o rhyme|$(LDFLAGS) &|g' \
		|| die "sed Makefile"
}

src_compile() {
	# Disable parallell building wrt bug #125967
	emake -j1 CC="$(tc-getCC)" FLAGS="${CFLAGS}" || die "emake failed"
}

src_install() {
	# author doesnt use -D for install
	dodir /usr/share/rhyme /usr/bin /usr/share/man/man1

	einstall BINPATH="${D}"/usr/bin \
			MANPATH="${D}"/usr/share/man/man1 \
			RHYMEPATH="${D}"/usr/share/rhyme
}
