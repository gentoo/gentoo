# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{6,7,8} )
DISTUTILS_USE_SETUPTOOLS=rdepend
inherit distutils-r1

DESCRIPTION="CloudFormation Linter"
HOMEPAGE="https://pypi.org/project/cfn-lint/ https://github.com/aws-cloudformation/cfn-python-lint"
SRC_URI="https://github.com/aws-cloudformation/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"

RDEPEND="
	>=dev-python/aws-sam-translator-1.21.0[${PYTHON_USEDEP}]
	dev-python/importlib_resources[${PYTHON_USEDEP}]
	dev-python/jsonpatch[${PYTHON_USEDEP}]
	>=dev-python/jsonschema-3.0[${PYTHON_USEDEP}]
	dev-python/networkx[${PYTHON_USEDEP}]
	dev-python/pyyaml[${PYTHON_USEDEP}]
	>=dev-python/requests-2.15.0[${PYTHON_USEDEP}]
	>=dev-python/six-1.11[${PYTHON_USEDEP}]
"

PATCHES=(
	"${FILESDIR}/cfn-python-lint-0.30.1-tests.patch"
)

python_test() {
	distutils_install_for_testing
	PATH="${TEST_DIR}/scripts:${PATH}" \
		"${EPYTHON}" -m unittest discover -v || die "tests fail with ${EPYTHON}"
}
