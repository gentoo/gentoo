# Copyright 2022-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=poetry
PYTHON_COMPAT=( python3_{10..11} )

inherit distutils-r1

DESCRIPTION="Composable complex class support for attrs and dataclasses"
HOMEPAGE="
	https://pypi.org/project/cattrs/
	https://github.com/python-attrs/cattrs/
"
SRC_URI="
	https://github.com/python-attrs/cattrs/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	>=dev-python/attrs-20.1.0[${PYTHON_USEDEP}]
	$(python_gen_cond_dep '
		dev-python/exceptiongroup[${PYTHON_USEDEP}]
	' 3.{9..10})
"
BDEPEND="
	test? (
		>=dev-python/cbor2-5.4.6[${PYTHON_USEDEP}]
		>=dev-python/hypothesis-6.54.5[${PYTHON_USEDEP}]
		>=dev-python/immutables-0.18[${PYTHON_USEDEP}]
		>=dev-python/msgpack-1.0.2[${PYTHON_USEDEP}]
		>=dev-python/orjson-3.5.2[${PYTHON_USEDEP}]
		>=dev-python/pymongo-4.2.0[${PYTHON_USEDEP}]
		>=dev-python/pyyaml-6.0[${PYTHON_USEDEP}]
		>=dev-python/tomlkit-0.11.4[${PYTHON_USEDEP}]
		>=dev-python/ujson-5.4.0[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

src_prepare() {
	sed -e 's:--benchmark.*::' \
		-e '/addopts/d' \
		-i pyproject.toml || die
	distutils-r1_src_prepare
}

python_test() {
	epytest tests
}
