# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-calculators/pcalc/pcalc-3.ebuild,v 1.2 2015/06/24 13:39:08 vapier Exp $

EAPI=4

inherit toolchain-funcs

DESCRIPTION="the programmers calculator"
HOMEPAGE="https://github.com/vapier/pcalc"
SRC_URI="mirror://sourceforge/pcalc/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-linux ~x86-linux"
IUSE=""

DEPEND="sys-devel/flex"
RDEPEND=""

src_prepare() {
	sed -i -e "s:/usr:${EPREFIX}/usr:g" Makefile || die
}

src_configure() {
	tc-export CC
}
