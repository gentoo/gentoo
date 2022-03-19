# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )
DISTUTILS_USE_PEP517=setuptools
inherit distutils-r1

DESCRIPTION="Python port of markdown-it, Markdown parser"
HOMEPAGE="https://pypi.org/project/markdown-it-py/
	https://github.com/executablebooks/markdown-it-py"
SRC_URI="
	https://github.com/executablebooks/markdown-it-py/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ia64 ~ppc ~ppc64 ~s390 ~sparc ~x86"

RDEPEND="
	<dev-python/attrs-22[${PYTHON_USEDEP}]
	dev-python/mdurl[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/pytest-regressions[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

EPYTEST_DESELECT=(
	# Unimportant tests needing a new dep linkify
	tests/test_linkify.py::test_token_levels
	tests/test_port/test_fixtures.py::test_linkify
)

EPYTEST_IGNORE=(
	# No need to benchmark
	benchmarking/
)
