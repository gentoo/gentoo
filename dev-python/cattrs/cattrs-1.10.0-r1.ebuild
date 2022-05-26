# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=poetry
PYTHON_COMPAT=( python3_{8..10} )
inherit distutils-r1

DESCRIPTION="Composable complex class support for attrs and dataclasses"
HOMEPAGE="
	https://pypi.org/project/cattrs/
	https://github.com/python-attrs/cattrs/"
SRC_URI="
	https://github.com/python-attrs/cattrs/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 x86"

RDEPEND="
	>=dev-python/attrs-20.1.0[${PYTHON_USEDEP}]"
BDEPEND="
	test? (
		dev-python/hypothesis[${PYTHON_USEDEP}]
		dev-python/immutables[${PYTHON_USEDEP}]
	)"
# test_preconf:
#		dev-python/bson[${PYTHON_USEDEP}]
#		dev-python/msgpack[${PYTHON_USEDEP}]
#		dev-python/orjson[${PYTHON_USEDEP}]
#		dev-python/pyyaml[${PYTHON_USEDEP}]
#		dev-python/tomlkit[${PYTHON_USEDEP}]
#		dev-python/ujson[${PYTHON_USEDEP}]

distutils_enable_tests pytest

src_prepare() {
	sed -e 's:--benchmark.*::' \
		-e '/addopts/d' \
		-i pyproject.toml || die
	# backport pyproject.toml fix (50ba769c8349f5891b157d2bb7f06602822ac0a3)
	sed -e 's:group.dev.dependencies:dev-dependencies:' \
		-i pyproject.toml || die
	distutils-r1_src_prepare
}

python_test() {
	# unpackaged deps, see above
	epytest tests --ignore tests/test_preconf.py
}
