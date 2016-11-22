# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit toolchain-funcs

DESCRIPTION="MINPACK-1 Least Squares Fitting Library in C"
HOMEPAGE="http://www.physics.wisc.edu/~craigm/idl/cmpfit.html"
SRC_URI="http://www.physics.wisc.edu/~craigm/idl/down/${P}.tar.gz"

LICENSE="public-domain minpack"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="static-libs"

DOCS=( README DISCLAIMER )

src_compile() {
	if use static-libs; then
		$(tc-getCC) ${CFLAGS} -c mpfit.c || die "non-PIC compilation failed"
		$(tc-getAR) cr libmpfit.a mpfit.o || die "creation of static archive failed"
	fi
	$(tc-getCC) ${CFLAGS} -fPIC -c mpfit.c -o mpfit.so || die "PIC compilation failed"
	$(tc-getCC) ${LDFLAGS} -shared -Wl,-soname=libmpfit.so mpfit.so -lm -o libmpfit.so || die "linking failed"
}

src_test() {
	$(tc-getCC) ${CFLAGS} testmpfit.c -L. -lmpfit -lm -o testmpfit || die
	LD_LIBRARY_PATH=.:${LD_LIBRARY_PATH} ./testmpfit || die
}

src_install() {
	dolib.so libmpfit.so
	use static-libs && dolib.a libmpfit.a
	doheader mpfit.h
	einstalldocs
}
