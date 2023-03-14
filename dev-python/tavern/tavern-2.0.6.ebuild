# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=flit
PYTHON_COMPAT=( python3_{9..11} )

inherit distutils-r1

DESCRIPTION="A tool, library, and Pytest plugin for testing RESTful APIs"
HOMEPAGE="
	https://github.com/taverntesting/tavern/
	https://pypi.org/project/tavern/
"
SRC_URI="
	https://github.com/taverntesting/tavern/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-python/jmespath[${PYTHON_USEDEP}]
	dev-python/paho-mqtt[${PYTHON_USEDEP}]
	dev-python/pyjwt[${PYTHON_USEDEP}]
	dev-python/pykwalify[${PYTHON_USEDEP}]
	dev-python/pytest[${PYTHON_USEDEP}]
	dev-python/python-box[${PYTHON_USEDEP}]
	dev-python/pyyaml[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
	dev-python/stevedore[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/colorlog[${PYTHON_USEDEP}]
		dev-python/Faker[${PYTHON_USEDEP}]
		dev-python/jsonschema[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

src_prepare() {
	# strip unnecessary pins, upstream doesn't update them a lot
	sed -i -E -e 's:,?<=?[0-9.]+::' pyproject.toml || die
	distutils-r1_src_prepare
}

python_test() {
	epytest -p tavern
}
