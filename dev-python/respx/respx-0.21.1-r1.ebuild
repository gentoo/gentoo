# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..13} )

inherit distutils-r1

DESCRIPTION="Mock HTTPX with awesome request patterns and response side effects"
HOMEPAGE="
	https://lundberg.github.io/respx/
	https://pypi.org/project/respx/
	https://github.com/lundberg/respx/
"
# no tests in pypi sdist
SRC_URI="
	https://github.com/lundberg/respx/archive/refs/tags/${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 arm64 x86"

# https://bugs.gentoo.org/945735
# https://github.com/lundberg/respx/issues/277
RDEPEND="
	<dev-python/httpx-0.28.0[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/flask[${PYTHON_USEDEP}]
		dev-python/httpcore[${PYTHON_USEDEP}]
		dev-python/pytest-asyncio[${PYTHON_USEDEP}]
		dev-python/starlette[${PYTHON_USEDEP}]
		dev-python/trio[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

python_test() {
	epytest -p 'no:*' -p asyncio -o addopts=
}
