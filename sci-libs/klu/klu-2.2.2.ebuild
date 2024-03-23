# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

Sparse_PV="7.3.1"
Sparse_P="SuiteSparse-${Sparse_PV}"
DESCRIPTION="Sparse LU factorization for circuit simulation"
HOMEPAGE="https://people.engr.tamu.edu/davis/suitesparse.html"
SRC_URI="https://github.com/DrTimothyAldenDavis/SuiteSparse/archive/refs/tags/v${Sparse_PV}.tar.gz -> ${Sparse_P}.gh.tar.gz"

LICENSE="LGPL-2.1+"
SLOT="0/2"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~riscv ~sparc ~x86 ~amd64-linux ~x86-linux"
IUSE="doc test"
RESTRICT="!test? ( test )"

DEPEND=">=sci-libs/suitesparseconfig-${Sparse_PV}
	>=sci-libs/amd-3.2.1
	>=sci-libs/btf-2.2.1
	>=sci-libs/colamd-3.2.1
	>=sci-libs/cholmod-5.0.1"
RDEPEND="${DEPEND}"
BDEPEND="doc? ( virtual/latex-base )"

S="${WORKDIR}/${Sparse_P}/${PN^^}"

src_configure() {
	local mycmakeargs=(
		-DNSTATIC=ON
		-DDEMO=$(usex test)
	)
	cmake_src_configure
}

src_test() {
	# Because we are not using cmake_src_test,
	# we have to manually go to BUILD_DIR
	cd "${BUILD_DIR}"
	# Run demo files
	./klu_simple || die "failed testing"
	./kludemo  < "${S}"/Matrix/1c.mtx || die "failed testing"
	./kludemo  < "${S}"/Matrix/arrowc.mtx || die "failed testing"
	./kludemo  < "${S}"/Matrix/arrow.mtx || die "failed testing"
	./kludemo  < "${S}"/Matrix/impcol_a.mtx || die "failed testing"
	./kludemo  < "${S}"/Matrix/w156.mtx || die "failed testing"
	./kludemo  < "${S}"/Matrix/ctina.mtx || die "failed testing"
	./kluldemo < "${S}"/Matrix/1c.mtx || die "failed testing"
	./kluldemo < "${S}"/Matrix/arrowc.mtx || die "failed testing"
	./kluldemo < "${S}"/Matrix/arrow.mtx || die "failed testing"
	./kluldemo < "${S}"/Matrix/impcol_a.mtx || die "failed testing"
	./kluldemo < "${S}"/Matrix/w156.mtx || die "failed testing"
	./kluldemo < "${S}"/Matrix/ctina.mtx || die "failed testing"
}

src_install() {
	if use doc; then
		pushd "${S}/Doc"
		emake clean
		rm -rf *.pdf
		emake
		popd
		DOCS="${S}/Doc/*.pdf"
	fi
	cmake_src_install
}
