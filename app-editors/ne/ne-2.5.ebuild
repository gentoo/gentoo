# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils toolchain-funcs

DESCRIPTION="the nice editor, easy to use for the beginner and powerful for the wizard"
HOMEPAGE="http://ne.di.unimi.it/"
SRC_URI="${HOMEPAGE}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 x86 ~x86-interix ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~sparc-solaris ~x86-solaris"
IUSE=tinfo

DEPEND="
	>=sys-libs/ncurses-5.2[tinfo?]
"
RDEPEND="
	${DEPEND}
	dev-lang/perl
"

src_prepare() {
	sed -i -e 's/-O3//' src/makefile || die
}

src_configure() {
	if use tinfo; then
		sed -i -e 's|-lcurses|-ltinfo|g' src/makefile || die
	else
		sed -i -e 's|-lcurses|-lncurses|g' src/makefile || die
	fi
}

src_compile() {
	emake -C src CC="$(tc-getCC)" \
		NE_GLOBAL_DIR="/usr/share/ne" \
		OPTS="${CFLAGS}" \
		ne || die
}

src_install() {
	dobin src/ne

	insinto /usr/share/ne/syntax
	doins syntax/*.jsf

	doman doc/ne.1
	dohtml -r doc/html/.
	dodoc CHANGES README doc/*.{txt,pdf,texinfo} doc/default.*
}
