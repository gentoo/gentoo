# Copyright 2021-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} )
DISTUTILS_USE_PEP517=setuptools
DISTUTILS_EXT=1
inherit distutils-r1 pypi

DESCRIPTION="An extension class for memory allocation in cython"
HOMEPAGE="https://pypi.org/project/memory-allocator/
	https://github.com/sagemath/memory_allocator"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64"

BDEPEND="dev-python/cython[${PYTHON_USEDEP}]"

python_test() {
	# The test script tries to "import memory_allocator.test" which, so
	# long as a memory_allocator directory exists inside CWD, will look
	# for a memory_allocator/test.py there. But there is no such file;
	# the "test" module is a compiled extension. To let the search fall
	# back to the correct location, we temporarily rename the directory
	# that misleads it.
	mv memory_allocator mv_memory_allocator || die
	${EPYTHON} test.py || die
	mv mv_memory_allocator memory_allocator || die
}
