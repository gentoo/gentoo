# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python{2_7,3_3,3_4} )

inherit distutils-r1

DESCRIPTION="Message Passing Interface for Python"
HOMEPAGE="https://bitbucket.org/mpi4py/ https://pypi.python.org/pypi/mpi4py"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux"
IUSE="doc examples test"

RDEPEND="virtual/mpi"
DEPEND="${RDEPEND}
	test? ( dev-python/nose[${PYTHON_USEDEP}]
	virtual/mpi[romio] )"
DISTUTILS_IN_SOURCE_BUILD=1

PATCHES=( "${FILESDIR}"/${P}-py3-test-backport-1.patch "${FILESDIR}"/${P}-ldshared.patch )

python_prepare_all() {
	# not needed on install
	rm -r docs/source || die
	distutils-r1_python_prepare_all
}

src_compile() {
	export FAKEROOTKEY=1
	distutils-r1_src_compile
}

python_test() {
	echo "Beginning test phase"
	pushd "${BUILD_DIR}"/../ &> /dev/null
	mpiexec -n 2 "${PYTHON}" ./test/runtests.py -v || die "Testsuite failed under ${EPYTHON}"
	popd &> /dev/null
}

python_install_all() {
	use doc && local HTML_DOCS=( docs/. )
	use examples && local EXAMPLES=( demo/. )
	distutils-r1_python_install_all
}
