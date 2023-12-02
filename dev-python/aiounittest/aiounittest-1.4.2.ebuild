# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( pypy3 python3_{10..12} )

inherit distutils-r1

DESCRIPTION="Test asyncio code more easily"
HOMEPAGE="
	https://github.com/kwarunek/aiounittest/
	https://pypi.org/project/aiounittest/
"
SRC_URI="
	https://github.com/kwarunek/aiounittest/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 arm arm64 hppa ~ia64 ~m68k ~ppc ~ppc64 ~riscv sparc x86"

RDEPEND="
	dev-python/wrapt[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest
