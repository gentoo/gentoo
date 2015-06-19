# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-libs/taucs/taucs-2.2.ebuild,v 1.11 2013/02/21 21:22:10 jlec Exp $

EAPI=4

inherit eutils fortran-2 toolchain-funcs

DESCRIPTION="C library of sparse linear solvers"
HOMEPAGE="http://www.tau.ac.il/~stoledo/taucs/"
SRC_URI="http://www.tau.ac.il/~stoledo/${PN}/${PV}/${PN}.tgz -> ${P}.tgz"

SLOT="0"
LICENSE="LGPL-2.1"
IUSE="cilk doc static-libs"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"

RDEPEND="
	virtual/blas
	virtual/lapack
	|| ( sci-libs/metis sci-libs/parmetis )
	cilk? ( dev-lang/cilk )"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

S="${WORKDIR}"

src_prepare() {
	# test with cilk has memory leaks
	epatch "${FILESDIR}"/${P}-no-test-cilk.patch
}

src_configure() {
	cat > config/linux_shared.mk <<-EOF
		FC=$(tc-getFC)
		CC=$(tc-getCC)
		LD=$(tc-getFC)
		CFLAGS=${CFLAGS} -fPIC
		FFLAGS=${FFLAGS} -fPIC
		LDFLAGS=${LDFLAGS} -fPIC
		LIBBLAS=$($(tc-getPKG_CONFIG) --libs blas)
		LIBLAPACK=$($(tc-getPKG_CONFIG) --libs lapack)
		LIBF77=
	EOF

	echo "LIBMETIS=$($(tc-getPKG_CONFIG) --libs metis)" >> config/linux_shared.mk
	# no cat <<EOF because -o has a trailing space
	if use cilk; then
		echo "CILKC=cilkc" >> config/linux_shared.mk
		echo "CILKFLAGS=-O2 -I${EPREFIX}/usr/include/cilk -fPIC" >> config/linux_shared.mk
		echo "CILKOUTFLG=-o " >> config/linux_shared.mk
	fi
	sed -e 's/ -fPIC//g' \
		config/linux_shared.mk \
		> config/linux_static.mk || die
}

src_compile() {
	# not autotools configure
	if use static-libs; then
		./configure variant=_static || die
		emake
	fi
	./configure variant=_shared || die
	emake

	cd lib/linux_shared
	$(tc-getFC) ${LDFLAGS} -shared -Wl,-soname=libtaucs.so.1 \
		-Wl,--whole-archive libtaucs.a -Wl,--no-whole-archive \
		$($(tc-getPKG_CONFIG) --libs blas lapack metis) \
		-o libtaucs.so.1.0.0 \
		|| die "shared lib linking failed"
}

src_test() {
	LD_LIBRARY_PATH=lib/linux_shared \
		./testscript variant=_shared || die "compile test failed"
	if grep -q FAILED testscript.log; then
		eerror "Test failed. See ${S}/testscript.log"
		die "test failed"
	fi
}

src_install() {
	use static-libs && dolib.a lib/linux_static/libtaucs.a
	ln -s libtaucs.so.1.0.0 lib/linux_shared/libtaucs.so.1
	ln -s libtaucs.so.1 lib/linux_shared/libtaucs.so
	dolib.so lib/linux_shared/libtaucs.so*

	insinto /usr/include
	doins build/*/*.h src/*.h

	use doc && dodoc doc/*.pdf
}
