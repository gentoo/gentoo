# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit toolchain-funcs

DESCRIPTION="Allows streaming backup utilities to dump/restore from CD-R(W)s or DVD(+/-RW)s"
HOMEPAGE="http://www.muempf.de/index.html"
SRC_URI="http://www.muempf.de/down/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=app-cdr/cdrtools-1.11.28"
DEPEND=""

src_unpack() {
	unpack ${A}

	sed -i -e '/cd\(backup\|restore\)/,+1 s:CFLAGS:LDFLAGS:' \
		"${S}"/Makefile || die "sed Makefile failed"
}

src_compile() {
	emake CFLAGS="${CFLAGS}" CC="$(tc-getCC)" || die "make failed"
}

src_install() {
	dobin cdbackup cdrestore || die "dobin failed"
	doman cdbackup.1 cdrestore.1 || die "doman failed"
	dodoc CHANGES CREDITS README || die "dodoc failed"
}
