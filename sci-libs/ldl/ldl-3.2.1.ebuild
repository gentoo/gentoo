# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

Sparse_PV="7.3.1"
Sparse_P="SuiteSparse-${Sparse_PV}"
DESCRIPTION="Simple but educational LDL^T matrix factorization algorithm"
HOMEPAGE="https://people.engr.tamu.edu/davis/suitesparse.html"
SRC_URI="https://github.com/DrTimothyAldenDavis/SuiteSparse/archive/refs/tags/v${Sparse_PV}.tar.gz -> ${Sparse_P}.gh.tar.gz"

LICENSE="LGPL-2.1+"
SLOT="0/3"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc ~ppc64 ~riscv ~sparc ~x86 ~amd64-linux ~x86-linux"
IUSE="doc test"
RESTRICT="!test? ( test )"

DEPEND=">=sci-libs/suitesparseconfig-${Sparse_PV}
	>=sci-libs/amd-3.2.1"
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
	# Some programs assume that they can access the Matrix folder in ${S}
	ln -s "${S}/Matrix" || die "cannot link to the Matrix folder"
	# Run demo files
	local demofiles=(
		ldlsimple
		ldllsimple
		ldlmain
		ldllmain
		ldlamd
		ldllamd
	)
	for i in ${demofiles[@]}; do
		./"${i}" > "${i}.out" || die "failed to run test ${i}"
		diff "${S}/Demo/${i}.out" "${i}.out" || die "failed testing ${i}"
	done
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
