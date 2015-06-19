# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-libs/cmpfit/cmpfit-1.2.ebuild,v 1.2 2013/02/05 18:35:16 ulm Exp $

EAPI=4

inherit toolchain-funcs

DESCRIPTION="MINPACK-1 Least Squares Fitting Library in C"
HOMEPAGE="http://www.physics.wisc.edu/~craigm/idl/cmpfit.html"
SRC_URI="http://www.physics.wisc.edu/~craigm/idl/down/${P}.tar.gz"

LICENSE="public-domain minpack"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="static-libs"

src_compile() {
	if use static-libs; then
		$(tc-getCC) ${CFLAGS} -c mpfit.c || die
		$(tc-getAR) cr mpfit.a mpfit.o || die
	fi
	$(tc-getCC) ${CFLAGS} -fPIC -c mpfit.c -o mpfit.so|| die "compilation failed"
	$(tc-getCC) ${LDFLAGS} -shared -Wl,-soname=libmpfit.so mpfit.so -lm -o libmpfit.so || die
}

src_test() {
	$(tc-getCC) ${CFLAGS} testmpfit.c -L. -lmpfit -lm -o testmpfit || die
	LD_LIBRARY_PATH=.:${LD_LIBRARY_PATH} ./testmpfit || die
}

src_install() {
	dolib.so libmpfit.so
	use static-libs && dolib.a libmpfit.a
	insinto /usr/include
	doins mpfit.h

	dodoc README DISCLAIMER
}
