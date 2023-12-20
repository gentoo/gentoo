# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..11} )
inherit distutils-r1 pypi

DESCRIPTION="Message Passing Interface for Python"
HOMEPAGE="https://github.com/mpi4py/mpi4py https://pypi.org/project/mpi4py/"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~riscv x86 ~amd64-linux ~x86-linux"
IUSE="doc examples test"

RESTRICT="!test? ( test )"

RDEPEND="
	dev-python/cython[${PYTHON_USEDEP}]
	dev-python/numpy[${PYTHON_USEDEP}]
	virtual/mpi
"
DEPEND="${RDEPEND}
	test? (
		virtual/mpi[romio]
	)
"

DISTUTILS_IN_SOURCE_BUILD=1

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
	# spawn is not stable in OpenMPI 4
	# https://github.com/jsquyres/ompi/pull/4#issuecomment-806897758
	# oob_tcp_if_include lo is needed to allow test in systemd-nspawn container
	mpiexec --use-hwthread-cpus --mca btl tcp,self --mca oob_tcp_if_include lo \
		-n 1 "${PYTHON}" -B ./test/runtests.py -v \
		--exclude="test_msgspec" --exclude="test_spawn" ||
		die "Testsuite failed under ${EPYTHON}"
	popd &> /dev/null || die
}

python_install_all() {
	use doc && local HTML_DOCS=( docs/. )
	use examples && local DOCS=( demo )
	distutils-r1_python_install_all
}
