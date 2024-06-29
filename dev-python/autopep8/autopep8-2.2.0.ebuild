# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..13} pypy3 )
PYTHON_REQ_USE="threads(+)"

inherit distutils-r1 pypi

DESCRIPTION="Automatically formats Python code to conform to the PEP 8 style guide"
HOMEPAGE="
	https://github.com/hhatto/autopep8/
	https://pypi.org/project/autopep8/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm64 ~ia64 ~ppc ~ppc64 sparc x86 ~amd64-linux ~x86-linux"

RDEPEND="
	>=dev-python/pycodestyle-2.11.0[${PYTHON_USEDEP}]
	$(python_gen_cond_dep '
		dev-python/tomli[${PYTHON_USEDEP}]
	' 3.10)
"

distutils_enable_tests pytest
