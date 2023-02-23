# Copyright 2022-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=flit
PYTHON_COMPAT=( python3_{9..11} pypy3 )

inherit distutils-r1

DESCRIPTION="Python port of markdown-it, Markdown parser"
HOMEPAGE="
	https://pypi.org/project/markdown-it-py/
	https://github.com/executablebooks/markdown-it-py/
"
SRC_URI="
	https://github.com/executablebooks/markdown-it-py/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~m68k ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"

RDEPEND="
	<dev-python/linkify-it-py-3[${PYTHON_USEDEP}]
	dev-python/mdurl[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/pytest-regressions[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

EPYTEST_IGNORE=(
	# No need to benchmark
	benchmarking/
)
