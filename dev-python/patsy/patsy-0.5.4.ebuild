# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( pypy3 python3_{10..12} )

inherit distutils-r1 pypi

DESCRIPTION="Python module to describe statistical models and design matrices"
HOMEPAGE="
	https://patsy.readthedocs.io/en/latest/index.html
	https://github.com/pydata/patsy/
	https://pypi.org/project/patsy/
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux"

RDEPEND="
	dev-python/numpy[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
	!hppa? (
		dev-python/scipy[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest
