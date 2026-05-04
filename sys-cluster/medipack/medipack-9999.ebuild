# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake toolchain-funcs

MY_PN="MeDiPack"

DESCRIPTION="Message Differentiation Package"
HOMEPAGE="https://scicomp.rptu.de/software/medi/ https://github.com/SciCompKL/MeDiPack"

if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/SciCompKL/${MY_PN}.git"
else
	SRC_URI="
		https://github.com/SciCompKL/${MY_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
	"
	S="${WORKDIR}/${MY_PN}-${PV}"
	KEYWORDS="~amd64"
fi

LICENSE="LGPL-3"
# SONAME
SLOT="0/$(ver_cut 1-3)"

IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	virtual/mpi
"
DEPEND="${RDEPEND}
	test? (
		sys-cluster/codipack
	)
"

src_test() {
	# sed -e "s/-O3/$(get-flag '-O*')/" -i tests/Makefile || die
	sed -e "s/-O3 //" -i tests/Makefile || die

	local -x OMPI_CXX="ccache $(tc-getCXX)"
	local -x OMPI_CXXFLAGS="${CXXFLAGS}"

	local myemakeargs=(
		OPT="yes"
		MPI_MODERN="yes"

		# Makefile passes -n2 to mpiexec
		# "-j$(( $(makeopts_jobs) / 2 ))"
	)

	emake -C tests "${myemakeargs[@]}" | tee "${T}/test.log"

	grep 'Test ' "${T}/test.log"
	grep FAILURE "${T}/test.log" >/dev/null && die "tests failed"
}
