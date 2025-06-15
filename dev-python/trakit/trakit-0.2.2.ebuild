# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=poetry
PYTHON_COMPAT=( python3_{11..14} )

inherit distutils-r1 pypi

DESCRIPTION="Guess additional information from titles in media tracks"
HOMEPAGE="
	https://github.com/ratoaq2/trakit
	https://pypi.org/project/trakit/
"
# No tests in sdist
SRC_URI="https://github.com/ratoaq2/trakit/archive/refs/tags/${PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64"

RDEPEND="
	dev-python/babelfish[${PYTHON_USEDEP}]
	dev-python/pyyaml[${PYTHON_USEDEP}]
	dev-python/rebulk[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/unidecode[${PYTHON_USEDEP}]
	)
"

EPYTEST_DESELECT=(
	# Network
	tests/test_generate.py::test_generate_config
)

distutils_enable_tests pytest
