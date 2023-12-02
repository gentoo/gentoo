# Copyright 2019-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYPI_NO_NORMALIZE=1
PYPI_PN=${PN^}
PYTHON_COMPAT=( python3_{10..12} pypy3 )

inherit distutils-r1 pypi

DESCRIPTION="Python @deprecated decorator to deprecate old API"
HOMEPAGE="
	https://github.com/tantale/deprecated/
	https://pypi.org/project/Deprecated/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ppc ppc64 ~riscv sparc x86"

RDEPEND="
	dev-python/wrapt[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest
