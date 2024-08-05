# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit flag-o-matic fortran-2 java-pkg-2 toolchain-funcs

DESCRIPTION="Molecular modeling package that includes force fields, such as AMBER and CHARMM"
HOMEPAGE="https://dasher.wustl.edu/tinker/"
SRC_URI="https://dasher.wustl.edu/${PN}/downloads/${P}.tar.gz"

SLOT="0"
LICENSE="Tinker"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="examples"
RESTRICT="mirror"

COMMON_DEPEND="
	>=sci-libs/fftw-3.2.2-r1[fortran,threads]
	dev-libs/maloc
	!sys-apps/bar
	!dev-util/diffuse
"
RDEPEND="${COMMON_DEPEND}
	>=virtual/jre-1.8:*
"
DEPEND="
	${COMMON_DEPEND}
	>=virtual/jdk-1.8:*
"
BDEPEND="virtual/pkgconfig"

S="${WORKDIR}"/${PN}/source

pkg_pretend() {
	[[ ${MERGE_TYPE} != binary ]] && tc-check-openmp
}

pkg_setup() {
	[[ ${MERGE_TYPE} != binary ]] && tc-check-openmp

	fortran-2_pkg_setup
}

src_prepare() {
	sed 's:strip:true:g' -i ../make/Makefile || die
	[[ $(tc-getFC) =~ "ifort" ]] && eapply "${FILESDIR}"/${PV}-openmp.patch
	default
	java-pkg-2_src_prepare
}

src_compile() {
	# tests fail with weird results under LTO
	# https://bugs.gentoo.org/878059
	# https://github.com/TinkerTools/tinker/issues/159
	filter-lto

	local javalib= _omplib _fftwlib
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
		rename_bin
}

src_test() {
	local test
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
