# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-calculators/pcalc/pcalc-2.ebuild,v 1.5 2014/12/30 23:28:23 vapier Exp $

EAPI=4

inherit toolchain-funcs

DESCRIPTION="the programmers calculator"
HOMEPAGE="http://pcalc.sourceforge.net/"
SRC_URI="mirror://sourceforge/pcalc/${P}.tar.lzma"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86 ~amd64-linux ~x86-linux"
IUSE=""

DEPEND="sys-devel/flex"
RDEPEND=""

src_prepare() {
	sed -i -e "s:/usr:${EPREFIX}/usr:g" Makefile || die
}

src_compile() {
	tc-export CC
	emake pcalc
}
