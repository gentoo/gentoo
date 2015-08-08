# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit toolchain-funcs

DESCRIPTION="a brainfuck interpreter"
HOMEPAGE="http://swapped.cc/bf/"
SRC_URI="http://swapped.cc/bf/files/${P}.tar.gz
	test? ( http://swapped.cc/bf/files/mandelbrot.b )"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 arm hppa ia64 m68k ppc ppc64 s390 sh x86"
IUSE="test"

DEPEND=""
RDEPEND=""

src_unpack() {
	unpack ${P}.tar.gz
	use test && cp "${DISTDIR}"/mandelbrot.b "${S}"/
}

src_compile() {
	$(tc-getCC) -Wall ${CFLAGS} ${LDFLAGS} -o bff bff.c || die "compile failed"
}

src_test() {
	ebegin "Running mandelbrot test"
	./bff mandelbrot.b > mandelbrot.out
	eend $? || die
	[[ $(md5sum mandelbrot.out) == "5024283fa65866ddd347b877798e84d8 "* ]] \
		&& cat mandelbrot.out \
		|| die "mandelbrot did not output correctly"
}

src_install() {
	dobin bff || die
	dodoc README
}
