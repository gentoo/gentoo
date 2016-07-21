# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit toolchain-funcs

DESCRIPTION="yet another free document preparation system"
HOMEPAGE="http://www.chiark.greenend.org.uk/~sgtatham/halibut/"
SRC_URI="http://www.chiark.greenend.org.uk/~sgtatham/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

src_compile() {
	tc-export CC
	CFLAGS="${CFLAGS} ${CPPFLAGS}" \
	LFLAGS="${LDFLAGS}" \
	emake -j1 \
		BUILDDIR="${S}/build" \
		VERSION="${PV}" \
		|| die "make failed"

	emake -C doc || die "make in doc failed"
}

src_install() {
	dobin build/halibut || die
	doman doc/halibut.1 || die
	dodoc doc/halibut.txt
	dohtml doc/*.html
}
