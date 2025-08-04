# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=poetry
PYTHON_COMPAT=( python3_{11..14} )

inherit distutils-r1 pypi

DESCRIPTION="Guess additional information from titles in media tracks"
HOMEPAGE="
	https://github.com/ratoaq2/trakit/
	https://pypi.org/project/trakit/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"

RDEPEND="
	>=dev-python/babelfish-0.6.0[${PYTHON_USEDEP}]
	>=dev-python/pyyaml-6.0.2[${PYTHON_USEDEP}]
	>=dev-python/rebulk-3.1.0[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		>=dev-python/unidecode-1.3.6[${PYTHON_USEDEP}]
	)
"

EPYTEST_DESELECT=(
	# Network
	tests/test_generate.py::test_generate_config
)

EPYTEST_PLUGINS=()
distutils_enable_tests pytest

src_prepare() {
	distutils-r1_src_prepare

	# sigh, poetry
	sed -i -e 's:\^:>=:' pyproject.toml || die
}
