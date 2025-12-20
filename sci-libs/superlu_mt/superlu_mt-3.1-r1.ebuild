# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

MY_PN=SuperLU_MT
SOVERSION=$(ver_cut 1)

DESCRIPTION="Multithreaded sparse LU factorization library"
HOMEPAGE="https://portal.nersc.gov/project/sparse/superlu/"
SRC_URI="https://portal.nersc.gov/project/sparse/superlu/${PN}_${PV}.tar.gz"

LICENSE="BSD"
SLOT="0/${SOVERSION}"
KEYWORDS="amd64 ~arm ~arm64 ~ppc ~ppc64 ~riscv ~x86"
IUSE="doc examples int64 openmp static-libs test threads"
RESTRICT="!test? ( test )"
REQUIRED_USE="|| ( openmp threads )"

RDEPEND="virtual/blas"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig
	test? ( app-shells/tcsh )"

S="${WORKDIR}/${MY_PN}_${PV}"

PATCHES=(
	"${FILESDIR}"/${PN}-3.1-duplicate-symbols.patch
	"${FILESDIR}"/${PN}-3.1-fix-predefs.patch
)

pkg_pretend() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && ! use threads && tc-check-openmp
}

pkg_setup() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && ! use threads && tc-check-openmp
}

src_prepare() {
	default
	cat <<-EOF > make.inc
		CC=$(tc-getCC)
		LOADER=$(tc-getCC)
		ARCH=$(tc-getAR)
		RANLIB=$(tc-getRANLIB)
		PREDEFS=${CPPFLAGS} -DUSE_VENDOR_BLAS -DPRNTlevel=0 -DDEBUGlevel=0 $(use int64 && echo -D_LONGINT)
		CDEFS=-DAdd_
		CFLAGS=${CFLAGS} ${CTHREADS} \$(PIC)
		BLASLIB=$($(tc-getPKG_CONFIG) --libs blas)
		MATHLIB=-lm
		NOOPTS=-O0 \$(PIC)
		ARCHFLAGS=cr
		LOADOPTS=${LDFLAGS} ${LDTHREADS}
		SUPERLULIB=lib${PN}.a
		TMGLIB=libtmglib.a
	EOF
	SONAME=lib${PN}.so.${SOVERSION}
	sed -e "s|../SRC|${EPREFIX}/usr/include/${PN}|" \
		-e '/:.*$(SUPERLULIB)/s|../lib/$(SUPERLULIB)||g' \
		-e 's|../lib/$(SUPERLULIB)|-lsuperlu_mt|g' \
		-i EXAMPLE/Makefile || die

	if use openmp && ! use threads; then
		CTHREADS="-D__OPENMP"
		LDTHREADS="-fopenmp"
	else
		CTHREADS="-D__PTHREAD"
		LDTHREADS="-pthread"
	fi
}

src_compile() {
	# shared library
	emake PIC="-fPIC" \
		ARCH="echo" \
		ARCHFLAGS="" \
		RANLIB="echo" \
		superlulib
	$(tc-getCC) ${LDFLAGS} ${LDTHREADS} -shared -Wl,-soname=${SONAME} SRC/*.o \
				$($(tc-getPKG_CONFIG) --libs blas) -lm -o lib/${SONAME} || die
	ln -s ${SONAME} lib/libsuperlu_mt.so || die

	use static-libs && rm -f SRC/*.o &&	\
		emake  PIC="" superlulib
}

src_test() {
	emake -j1 tmglib
	LD_LIBRARY_PATH="${S}/lib:${LD_LIBRARY_PATH}" \
		emake SUPERLULIB="${SONAME}" testing
}

src_install() {
	dolib.so lib/*so*
	use static-libs && dolib.a lib/*.a
	insinto /usr/include/${PN}
	doins SRC/*h
	dodoc README
	use doc && dodoc DOC/ug.pdf
	if use examples; then
		docinto /examples
		dodoc -r EXAMPLE/* make.inc
	fi
}
