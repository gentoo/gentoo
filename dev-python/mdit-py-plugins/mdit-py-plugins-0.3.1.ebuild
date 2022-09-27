# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=flit
PYTHON_COMPAT=( python3_{8..11} pypy3 )

inherit distutils-r1

DESCRIPTION="Collection of plugins for markdown-it-py"
HOMEPAGE="
	https://pypi.org/project/mdit-py-plugins/
	https://github.com/executablebooks/mdit-py-plugins/
"
SRC_URI="
	https://github.com/executablebooks/mdit-py-plugins/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"

RDEPEND="
	dev-python/markdown-it-py[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/pytest-regressions[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest
