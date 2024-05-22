# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYPI_NO_NORMALIZE=1
PYPI_PN=${PN/-/.}
PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1 pypi

DESCRIPTION="A locking API for expiring values while a single thread generates a new value"
HOMEPAGE="
	https://github.com/sqlalchemy/dogpile.cache/
	https://pypi.org/project/dogpile.cache/
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ~riscv x86"

RDEPEND="
	>=dev-python/decorator-4.0.0[${PYTHON_USEDEP}]
	>=dev-python/stevedore-3.0.0[${PYTHON_USEDEP}]
	$(python_gen_cond_dep '
		>=dev-python/typing-extensions-4.0.1[${PYTHON_USEDEP}]
	' 3.10)
"
BDEPEND="
	test? (
		dev-python/mako[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest
