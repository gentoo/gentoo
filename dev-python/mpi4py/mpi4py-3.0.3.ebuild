# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7,8,9} )
inherit distutils-r1

DESCRIPTION="Message Passing Interface for Python"
HOMEPAGE="https://bitbucket.org/mpi4py/ https://pypi.org/project/mpi4py/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm x86 ~amd64-linux ~x86-linux"
IUSE="doc examples test"

RESTRICT="!test? ( test )"

RDEPEND="
	dev-python/cython[${PYTHON_USEDEP}]
	dev-python/numpy[${PYTHON_USEDEP}]
	virtual/mpi
"
DEPEND="${RDEPEND}
	test? (
		dev-python/nose[${PYTHON_USEDEP}]
		virtual/mpi[romio]
	)
"

DISTUTILS_IN_SOURCE_BUILD=1

PATCHES=(
	"${FILESDIR}/${P}-py38setup.patch"
	"${FILESDIR}/${P}-py38futures.patch"
)

python_prepare_all() {
	# not needed on install
	rm -vr docs/source || die
	rm test/test_pickle.py || die # disabled by Gentoo-bug #659348
	distutils-r1_python_prepare_all
}

src_compile() {
	export FAKEROOTKEY=1
	distutils-r1_src_compile
}

python_test() {
	echo "Beginning test phase"
	pushd "${BUILD_DIR}"/../ &> /dev/null || die
	mpiexec --use-hwthread-cpus --mca btl tcp,self -n 1 "${PYTHON}" -B ./test/runtests.py -v --exclude="test_msgspec" ||
		die "Testsuite failed under ${EPYTHON}"
	popd &> /dev/null || die
}

python_install_all() {
	use doc && local HTML_DOCS=( docs/. )
	use examples && local DOCS=( demo )
	distutils-r1_python_install_all
}
