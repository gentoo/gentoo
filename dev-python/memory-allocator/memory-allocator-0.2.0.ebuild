# Copyright 2021-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=meson-python
PYPI_VERIFY_REPO=https://github.com/sagemath/memory_allocator
PYTHON_COMPAT=( python3_{12..14} )

inherit distutils-r1 pypi

DESCRIPTION="An extension class for memory allocation in cython"
HOMEPAGE="
	https://pypi.org/project/memory-allocator/
	https://github.com/sagemath/memory_allocator/
"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~riscv"

BDEPEND="
	dev-python/cython[${PYTHON_USEDEP}]
"

python_test() {
	# The test script tries to "import memory_allocator.test" which, so
	# long as a memory_allocator directory exists inside CWD, will look
	# for a memory_allocator/test.py there. But there is no such file;
	# the "test" module is a compiled extension. To let the search fall
	# back to the correct location, we temporarily rename the directory
	# that misleads it.
	rm -rf memory_allocator || die
	"${EPYTHON}" test.py || die
}
