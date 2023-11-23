# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1

DESCRIPTION="A helper for using rope refactoring library in IDEs"
HOMEPAGE="
	https://github.com/python-rope/ropemode/
	https://pypi.org/project/ropemode/
"
SRC_URI="
	https://github.com/python-rope/ropemode/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"

RDEPEND="
	dev-python/rope[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest
