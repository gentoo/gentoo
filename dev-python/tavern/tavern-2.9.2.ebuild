# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=flit
PYTHON_COMPAT=( python3_{10..12} )

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
	>=dev-python/jmespath-1[${PYTHON_USEDEP}]
	>=dev-python/jsonschema-4[${PYTHON_USEDEP}]
	>=dev-python/paho-mqtt-1.3.1[${PYTHON_USEDEP}]
	>=dev-python/pyjwt-2.5.0[${PYTHON_USEDEP}]
	>=dev-python/pykwalify-1.8.0[${PYTHON_USEDEP}]
	>=dev-python/pytest-7[${PYTHON_USEDEP}]
	>=dev-python/python-box-6[${PYTHON_USEDEP}]
	>=dev-python/pyyaml-6.0.1[${PYTHON_USEDEP}]
	>=dev-python/requests-2.22.0[${PYTHON_USEDEP}]
	>=dev-python/stevedore-4[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/colorlog[${PYTHON_USEDEP}]
		dev-python/Faker[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

src_prepare() {
	# strip unnecessary pins, upstream doesn't update them a lot
	sed -i -E -e 's:,?<=?[0-9.]+::' pyproject.toml || die
	distutils-r1_src_prepare
}

python_test() {
	local EPYTEST_DESELECT=(
		# requires grpc
		tests/unit/test_extensions.py::TestGrpcCodes
	)
	local EPYTEST_IGNORE=(
		# require grpc*
		tavern/_plugins/grpc
		tests/unit/tavern_grpc
	)

	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	epytest -p tavern
}
