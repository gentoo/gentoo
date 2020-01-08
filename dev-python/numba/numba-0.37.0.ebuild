# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python{2_7,3_6} )

inherit distutils-r1

DESCRIPTION="NumPy aware dynamic Python compiler using LLVM"
HOMEPAGE="http://numba.pydata.org/"
SRC_URI="https://github.com/${PN}/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux"
IUSE="examples test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-python/llvmlite-0.22.0[${PYTHON_USEDEP}]
	dev-python/numpy[${PYTHON_USEDEP}]
	virtual/python-enum34[${PYTHON_USEDEP}]
	virtual/python-funcsigs[${PYTHON_USEDEP}]
	virtual/python-singledispatch[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (	dev-python/pytest[${PYTHON_USEDEP}] )
"

PATCHES=(
	"${FILESDIR}"/numba-skip-tests.patch
)

python_test() {
	cd "${BUILD_DIR}/lib" || die
	${EPYTHON} -m numba.runtests -v || die
}

python_install_all() {
	distutils-r1_python_install_all
	if use examples; then
		insinto /usr/share/doc/${PF}
		doins -r examples
		docompress -x /usr/share/doc/${PF}/examples
	fi
}
