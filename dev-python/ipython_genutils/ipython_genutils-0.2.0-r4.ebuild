# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} )

inherit distutils-r1 pypi

DESCRIPTION="Vestigial utilities from IPython"
HOMEPAGE="https://github.com/ipython/ipython_genutils"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 arm arm64 hppa ~ia64 ~loong ppc ppc64 ~riscv ~s390 sparc x86"

# Needed because package provides decorators which use pytest (after patch)
RDEPEND="dev-python/pytest[${PYTHON_USEDEP}]"

PATCHES=(
	"${FILESDIR}/${P}-remove-nose.patch"
)

distutils_enable_tests pytest
