# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYPI_NO_NORMALIZE=1
PYPI_PN=${PN/-/.}
PYTHON_COMPAT=( pypy3 python3_{10..12} )

inherit distutils-r1 pypi

DESCRIPTION="More sophisticated version manipulation (than packaging)"
HOMEPAGE="
	https://github.com/jaraco/jaraco.versioning/
	https://pypi.org/project/jaraco.versioning/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"

RDEPEND="
	dev-python/packaging[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest
