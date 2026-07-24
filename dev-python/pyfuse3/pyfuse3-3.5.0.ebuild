# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=standalone
PYTHON_COMPAT=( python3_{12..15} )

inherit distutils-r1 pypi

DESCRIPTION="Python 3 bindings for libfuse 3 with asynchronous API"
HOMEPAGE="
	https://github.com/libfuse/pyfuse3/
	https://pypi.org/project/pyfuse3/
"

LICENSE="LGPL-2.1+"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~riscv ~x86"

DEPEND="
	sys-fs/fuse:3=
"
RDEPEND="
	${DEPEND}
	>=dev-python/trio-0.15[${PYTHON_USEDEP}]
"
BDEPEND="
	dev-python/cython[${PYTHON_USEDEP}]
	dev-python/setuptools[${PYTHON_USEDEP}]
	>=dev-python/setuptools-scm-8.0[${PYTHON_USEDEP}]
"

EPYTEST_PLUGINS=( pytest-trio )
distutils_enable_tests pytest
