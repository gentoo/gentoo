# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils flag-o-matic fortran-2 java-pkg-opt-2 toolchain-funcs

DESCRIPTION="Molecular modeling package that includes force fields, such as AMBER and CHARMM"
HOMEPAGE="http://dasher.wustl.edu/tinker/"
SRC_URI="http://dasher.wustl.edu/${PN}/downloads/${P}.tar.gz"

SLOT="0"
LICENSE="Tinker"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="examples"

DEPEND="
	>=virtual/jdk-1.6"
RDEPEND="
	>=sci-libs/fftw-3.2.2-r1[fortran,threads]
	dev-libs/maloc
	!dev-util/diffuse
	>=virtual/jre-1.6"

RESTRICT="mirror"

S="${WORKDIR}"/${PN}/source

pkg_setup() {
	fortran-2_pkg_setup
	java-pkg-opt-2_pkg_setup
	tc-has-openmp || die "Please use an openmp capable compiler like gcc[openmp]"
}

src_prepare() {
	sed 's:strip:true:g' -i ../make/Makefile
	[[ $(tc-getFC) =~ "ifort" ]] || epatch "${FILESDIR}"/${PV}-openmp.patch
	cd .. && epatch "${FILESDIR}"/${P}-build.patch
}

src_compile() {
	local javalib=
	for i in $(java-config -g LDPATH | sed 's|:| |g'); do
		[[ -f ${i}/libjvm.so ]] && javalib=${i}
	done

	# use dummy routines in pmpb.f instead of apbs calls
	rm pmpb.c || die

	if [[ $(tc-getFC) =~ "gfortran" ]]; then
		append-flags -fopenmp
		_omplib="-lgomp"
	else
		append-flags -openmp
		_omplib="-liomp5"
	fi

	_fftwlib="$($(tc-getPKG_CONFIG) --libs fftw3 fftw3_threads)"

	emake \
		-f ../make/Makefile \
		F77="$(tc-getFC)" \
		CC="$(tc-getCC) -c" \
		F77FLAGS=-c \
		OPTFLAGS="${FFLAGS}" \
		LINKFLAGS="${LDFLAGS} -Wl,-rpath ${javalib}" \
		INCLUDEDIR="$(java-pkg_get-jni-cflags) -I${EPREFIX}/usr/include" \
		LIBS="-lmaloc -L${javalib} -ljvm ${_omplib} ${_fftwlib}" \
		all

	mkdir "${S}"/../bin || die

	emake \
		-f ../make/Makefile \
		BINDIR="${S}"/../bin \
		rename
}

src_test() {
	cd "${WORKDIR}"/${PN}/test/
	for test in *.run; do
		einfo "Testing ${test} ..."
		bash ${test} || die
	done
}

src_install() {
	dobin "${WORKDIR}"/${PN}/perl/mdavg "${WORKDIR}"/${PN}/bin/*

	insinto /usr/share/${PN}/
	doins -r "${WORKDIR}"/${PN}/params

	dodoc \
		"${WORKDIR}"/${PN}/doc/{*.txt,*.pdf,0README}

	if use examples; then
		insinto /usr/share/${P}
		doins -r "${WORKDIR}"/${PN}/example

		doins -r "${WORKDIR}"/${PN}/test
	fi

}
