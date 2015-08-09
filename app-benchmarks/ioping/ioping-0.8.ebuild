# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils

DESCRIPTION="Simple disk I/0 latency measuring tool"
HOMEPAGE="http://code.google.com/p/ioping/"
SRC_URI="http://ioping.googlecode.com/files/${P}.tar.gz"

SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
LICENSE="GPL-3"
IUSE=""

src_prepare() {
	sed \
		-e 's: -g : :g' \
		-e 's: $(LDFLAGS) : :g' \
		-e 's: -o : $(LDFLAGS) -o :g' \
		-e 's:-s -m:-m:g' \
		-i Makefile || die
}

src_compile() {
	emake \
		CC="$(tc-getCC)" \
		PREFIX="${EPREFIX}/usr"
}

src_install() {
	emake DESTDIR="${D}" PREFIX="${EPREFIX}/usr" install
}
