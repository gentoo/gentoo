# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit flag-o-matic toolchain-funcs

MY_PV=${PV//./_}

DESCRIPTION="SHort Read Mapping Package"
HOMEPAGE="http://compbio.cs.toronto.edu/shrimp/"
SRC_URI="http://compbio.cs.toronto.edu/shrimp/releases/SHRiMP_${MY_PV}.src.tar.gz"

LICENSE="shrimp"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="custom-cflags"

# file collision on /usr/bin/utils #453044
DEPEND="
	!sci-biology/emboss
	!sci-mathematics/cado-nfs"
RDEPEND="${DEPEND}"

S=${WORKDIR}/SHRiMP_${MY_PV}

pkg_setup() {
	if [[ ${CC} == *gcc* ]] &&	! tc-has-openmp; then
		elog "Please set CC to an OPENMP capable compiler (e.g. gcc[openmp] or icc"
		die "C compiler lacks OPENMP support"
	fi
}

src_prepare() {
	sed -e '1 a #include <stdint.h>' -i common/dag_glue.cpp || die
	# respect LDFLAGS wrt 331823
	sed -i -e "s/LDFLAGS/LIBS/" -e "s/\$(LD)/& \$(LDFLAGS)/" \
		-e 's/-static//' Makefile || die
}

src_compile() {
	append-flags -fopenmp
	use custom-cflags || append-flags -O3 # per instructions in BUILDING
	tc-export CXX
	emake CXXFLAGS="${CXXFLAGS}" LDFLAGS="${LDFLAGS}"
}

src_install() {
	rm bin/README
	dobin bin/*
	insinto /usr/share/${PN}
	doins -r utils
	dodoc HISTORY README TODO SPLITTING_AND_MERGING
}
