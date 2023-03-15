# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} )

inherit distutils-r1 pypi

DESCRIPTION="Python 3 bindings for libfuse 3 with asynchronous API"
HOMEPAGE="
	https://github.com/libfuse/pyfuse3/
	https://pypi.org/project/pyfuse3/
"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~ppc64 ~riscv x86"

DEPEND="
	sys-fs/fuse:3
"
RDEPEND="
	${DEPEND}
	dev-python/trio[${PYTHON_USEDEP}]
"
BDEPEND="
	dev-python/cython[${PYTHON_USEDEP}]
	test? (
		dev-python/pytest-trio[${PYTHON_USEDEP}]
		sys-apps/which
	)
"

distutils_enable_tests pytest

python_configure() {
	esetup.py build_cython
}
