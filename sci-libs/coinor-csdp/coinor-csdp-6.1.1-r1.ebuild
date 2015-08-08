# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit versionator toolchain-funcs flag-o-matic  multilib

MYPN=Csdp

DESCRIPTION="COIN-OR C Library for Semi-Definite Programming"
HOMEPAGE="https://projects.coin-or.org/Csdp/"
SRC_URI="http://www.coin-or.org/download/source/${MYPN}/${MYPN}-${PV}.tgz"

LICENSE="CPL-1.0"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="doc examples openmp static-libs"

RDEPEND="
	virtual/blas
	virtual/lapack"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

S="${WORKDIR}/${MYPN}-${PV}"

static_to_shared() {
	local libstatic=${1}; shift
	local libname=$(basename ${libstatic%.a})
	local soname=${libname}$(get_libname $(get_version_component_range 1-2))
	local libdir=$(dirname ${libstatic})

	einfo "Making ${soname} from ${libstatic}"
	if [[ ${CHOST} == *-darwin* ]] ; then
		${LINK:-$(tc-getCC)} ${LDFLAGS}  \
			-dynamiclib -install_name "${EPREFIX}"/usr/lib/"${soname}" \
			-Wl,-all_load -Wl,${libstatic} \
			"$@" -o ${libdir}/${soname} || die "${soname} failed"
	else
		${LINK:-$(tc-getCC)} ${LDFLAGS}  \
			-shared -Wl,-soname=${soname} \
			-Wl,--whole-archive ${libstatic} -Wl,--no-whole-archive \
			"$@" -o ${libdir}/${soname} || die "${soname} failed"
		[[ $(get_version_component_count) -gt 1 ]] && \
			ln -s ${soname} ${libdir}/${libname}$(get_libname $(get_major_version))
		ln -s ${soname} ${libdir}/${libname}$(get_libname)
	fi
}

pkg_setup() {
	if use openmp && [[ $(tc-getCC) == *gcc* ]] && ! tc-has-openmp; then
		eerror "Your selected gcc compiler does not support OpenMP"
		die "OpenMP non capable gcc"
	fi
}

src_prepare() {
	find . -name Makefile -exec sed -i -e 's:make:$(MAKE):g' '{}' + || die
	append-cflags -DNOSHORTS -DUSEGETTIME -I../include
	if use openmp; then
		[[ $(tc-getCC) == *gcc* ]] && append-cflags -fopenmp \
			&& append-ldflags -fopenmp
		[[ $(tc-getCC) == *icc* ]] && append-cflags -openmp
			append-cflags -DUSEOPENMP
	fi
	use amd64 && append-cflags -DBIT64
	[[ $($(tc-getPKG_CONFIG) --libs blas) =~ atlas ]] && append-cflags -DUSEATLAS
	sed -i \
		-e "s:-O3:${CFLAGS} ${LDFLAGS}:" \
		-e "s:ar :$(tc-getAR) :" \
		*/Makefile || die

	tc-export CC
}

src_compile() {
	emake CFLAGS="${CFLAGS} -fPIC" -C lib
	local libs="$($(tc-getPKG_CONFIG) --libs blas lapack)"
	static_to_shared lib/libsdp.a ${libs}
	use static-libs && emake -C lib clean && emake -C lib
	emake -C solver LIBS="${libs} -L../lib -lsdp -lm"
	emake -C theta LIBS="${libs} -L../lib -lsdp -lm"
}

src_test() {
	LD_LIBRARY_PATH="${S}/lib" emake -C test
}

src_install() {
	dobin solver/csdp theta/{theta,graphtoprob,complement,rand_graph}
	dolib.so lib/libsdp$(get_libname)*
	use static-libs && dolib.a lib/libsdp.a
	insinto /usr/include/${PN}
	doins include/*
	dodoc AUTHORS README
	use doc && dodoc doc/csdpuser.pdf
	if use examples; then
		insinto /usr/share/doc/${PF}/examples
		doins example/*
	fi
}
