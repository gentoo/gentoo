# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYPI_PN=${PN/-/_}
PYTHON_COMPAT=( pypy3_11 python3_{11..14} )

inherit distutils-r1 pypi

DESCRIPTION="Vestigial utilities from IPython"
HOMEPAGE="
	https://github.com/ipython/ipython_genutils/
	https://pypi.org/project/ipython_genutils/
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 arm arm64 hppa ~loong ppc ppc64 ~riscv ~s390 sparc x86"

# Needed because package provides decorators which use pytest (after patch)
RDEPEND="
	dev-python/pytest[${PYTHON_USEDEP}]
"

PATCHES=(
	"${FILESDIR}/${P}-remove-nose.patch"
)

distutils_enable_tests pytest
