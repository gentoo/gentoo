# Copyright 2019-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYPI_NO_NORMALIZE=1
PYPI_PN=${PN^}
PYTHON_COMPAT=( python3_{10..13} pypy3 )

inherit distutils-r1 pypi

DESCRIPTION="Python @deprecated decorator to deprecate old API"
HOMEPAGE="
	https://github.com/tantale/deprecated/
	https://pypi.org/project/Deprecated/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ppc ppc64 ~riscv ~s390 sparc x86"

RDEPEND="
	dev-python/wrapt[${PYTHON_USEDEP}]
"

PATCHES=(
	"${FILESDIR}/${P}-py313.patch"
)

distutils_enable_tests pytest
