# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

Sparse_PV="7.3.1"
Sparse_P="SuiteSparse-${Sparse_PV}"
DESCRIPTION="a software package for SParse EXact algebra"
HOMEPAGE="https://people.engr.tamu.edu/davis/suitesparse.html"
SRC_URI="https://github.com/DrTimothyAldenDavis/SuiteSparse/archive/refs/tags/v${Sparse_PV}.tar.gz -> ${Sparse_P}.gh.tar.gz"

LICENSE="BSD"
SLOT="0/2"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86 ~amd64-linux ~x86-linux"
IUSE="doc test"
RESTRICT="!test? ( test )"

DEPEND=">=sci-libs/suitesparseconfig-${Sparse_PV}
	>=sci-libs/amd-3.2.1
	>=sci-libs/colamd-3.2.1
	dev-libs/gmp
	dev-libs/mpfr"
RDEPEND="${DEPEND}"
BDEPEND="doc? ( virtual/latex-base )"

PATCHES=(
	"${FILESDIR}/${PN}-2.0.0-demo_location.patch"
	)

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
	# Programs expect to find ExampleMats
	ln -s "${S}/SPEX_Left_LU/ExampleMats"
	# Run demo files
	./example || die "failed testing"
	./example2 || die "failed testing"
	./spexlu_demo || die "failed testing"
}

src_install() {
	if use doc; then
		pushd "${S}/Doc"
		rm -rf *.pdf
		emake
		popd
		DOCS="${S}/Doc/*.pdf"
	fi
	cmake_src_install
}
