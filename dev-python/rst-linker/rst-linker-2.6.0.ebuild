# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( pypy3 python3_{10..13} )

inherit distutils-r1 pypi

DESCRIPTION="Sphinx plugin to add links and timestamps to the changelog"
HOMEPAGE="
	https://github.com/jaraco/rst.linker/
	https://pypi.org/project/rst.linker/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~mips ppc ppc64 ~riscv ~s390 sparc x86"

RDEPEND="
	dev-python/jaraco-context[${PYTHON_USEDEP}]
	>=dev-python/jaraco-vcs-2.1[${PYTHON_USEDEP}]
"
BDEPEND="
	>=dev-python/setuptools-scm-3.4.1[${PYTHON_USEDEP}]
	test? (
		dev-python/path[${PYTHON_USEDEP}]
		dev-python/pytest-subprocess[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest
