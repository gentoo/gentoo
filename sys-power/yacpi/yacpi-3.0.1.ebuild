# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=3
inherit toolchain-funcs

DESCRIPTION="Yet Another Configuration and Power Interface"
HOMEPAGE="http://www.ngolde.de/yacpi.html"
SRC_URI="http://www.ngolde.de/download/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="sys-libs/libacpi
	sys-libs/ncurses"

src_prepare() {
	sed -i \
		-e 's:= -O2 -Wall -g:+= -Wall:' \
		-e 's:${CC} -Wall:${CC} ${LDFLAGS} ${CFLAGS}:' \
		-e '/strip/d' \
		-e 's:COPYING::' \
		Makefile || die
}

src_compile() {
	emake CC="$(tc-getCC)" || die
}

src_install() {
	emake \
		prefix="${D}/usr" \
		DOCPATH="${D}/usr/share/doc/${PF}" \
		install || die

	prepalldocs
}
