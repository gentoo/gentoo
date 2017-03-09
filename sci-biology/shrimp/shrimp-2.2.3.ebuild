# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit flag-o-matic python-single-r1 toolchain-funcs

MY_PV=${PV//./_}

DESCRIPTION="SHort Read Mapping Package"
HOMEPAGE="http://compbio.cs.toronto.edu/shrimp/"
SRC_URI="http://compbio.cs.toronto.edu/shrimp/releases/SHRiMP_${MY_PV}.src.tar.gz"

LICENSE="shrimp"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="custom-cflags +cpu_flags_x86_sse2"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

# file collision on /usr/bin/utils #453044
DEPEND="!sci-mathematics/cado-nfs"
RDEPEND="${DEPEND}
	${PYTHON_DEPS}"

S=${WORKDIR}/SHRiMP_${MY_PV}

pkg_pretend() {
	use cpu_flags_x86_sse2 || die "This package needs sse2 support in your CPU"
}

pkg_setup() {
	if [[ ${CC} == *gcc* ]] &&	! tc-has-openmp; then
		elog "Please set CC to an OPENMP capable compiler (e.g. gcc[openmp] or icc"
		die "C compiler lacks OPENMP support"
	fi
	python-single-r1_pkg_setup
}

src_prepare() {
	sed \
		-e '1 a #include <stdint.h>' \
		-i common/dag_glue.cpp || die
	# respect LDFLAGS wrt 331823
	sed \
		-e "s/LDFLAGS/LIBS/" \
		-e "s/\$(LD)/& \$(LDFLAGS)/" \
		-e 's/-static//' \
		-i Makefile || die

	append-flags -fopenmp
	if ! use custom-cflags; then
		append-flags -O3
		replace-flags -O* -O3
	fi
	tc-export CXX

	cd utils || die
	sed -e '/^#!/d' -i *py || die
	sed -e '1i#!/usr/bin/python' -i *py || die
}

src_compile() {
	emake CXXFLAGS="${CXXFLAGS}" LDFLAGS="${LDFLAGS}"
}

src_install() {
	local i
	newdoc bin/README README.bin && rm bin/README
	dobin bin/* utils/split-contigs utils/temp-sink
	dodoc HISTORY README TODO SPLITTING_AND_MERGING SCORES_AND_PROBABILITES

	pushd utils > /dev/null

	python_doscript *py

	rm *.py *.o *.c split-contigs temp-sink || die
	insinto /usr/share/${PN}
	doins -r *
}
