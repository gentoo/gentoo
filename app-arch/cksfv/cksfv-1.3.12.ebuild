# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit toolchain-funcs

DESCRIPTION="SFV checksum utility (simple file verification)"
HOMEPAGE="http://zakalwe.fi/~shd/foss/cksfv/"
SRC_URI="http://zakalwe.fi/~shd/foss/cksfv/files/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 hppa ~ia64 ppc sparc x86 ~x86-fbsd"
IUSE=""

DEPEND=""

src_compile() {
	# note: not an autoconf configure script
	./configure \
		--compiler=$(tc-getCC) \
		--prefix=/usr \
		--package-prefix="${D}" \
		--bindir=/usr/bin \
		--mandir=/usr/share/man || die
	emake || die
}

src_install() {
	emake install || die
	dodoc ChangeLog README TODO
}
