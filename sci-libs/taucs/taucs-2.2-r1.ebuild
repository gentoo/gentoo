# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit fortran-2 toolchain-funcs

DESCRIPTION="C library of sparse linear solvers"
HOMEPAGE="http://www.tau.ac.il/~stoledo/taucs/"
SRC_URI="http://www.tau.ac.il/~stoledo/${PN}/${PV}/${PN}.tgz -> ${P}.tgz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="doc"
RESTRICT="test"

RDEPEND="
	virtual/blas
	virtual/lapack
	|| (
		sci-libs/metis
		sci-libs/parmetis
	)"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

S="${WORKDIR}"

PATCHES=(
	# bug 725588
	"${FILESDIR}"/${P}-respect-ar.patch
)

src_configure() {
	cat > config/linux_shared.mk <<-EOF || die
		AR=$(tc-getAR)
		FC=$(tc-getFC)
		CC=$(tc-getCC)
		LD=$(tc-getFC)
		RANLIB=$(tc-getRANLIB)
		CFLAGS=${CFLAGS} -fPIC
		FFLAGS=${FFLAGS} -fPIC
		LDFLAGS=${LDFLAGS} -fPIC
		LIBBLAS=$($(tc-getPKG_CONFIG) --libs blas)
		LIBLAPACK=$($(tc-getPKG_CONFIG) --libs lapack)
		LIBF77=
	EOF

	echo "LIBMETIS=$($(tc-getPKG_CONFIG) --libs metis)" >> config/linux_shared.mk || die
	# no cat <<EOF because -o has a trailing space
	sed -e 's/ -fPIC//g' config/linux_shared.mk || die
}

src_compile() {
	# not autotools configure
	CC=$(tc-getCC) ./configure variant=_shared || die
	emake

	cd lib/linux_shared || die
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
	ln -s libtaucs.so.1.0.0 lib/linux_shared/libtaucs.so.1 || die
	ln -s libtaucs.so.1 lib/linux_shared/libtaucs.so || die
	dolib.so lib/linux_shared/libtaucs.so*

	doheader build/*/*.h src/*.h

	use doc && dodoc doc/*.pdf
}
