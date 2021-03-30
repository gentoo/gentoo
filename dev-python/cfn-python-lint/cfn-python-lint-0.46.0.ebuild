# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{7..9} )
DISTUTILS_USE_SETUPTOOLS=rdepend
inherit distutils-r1

DESCRIPTION="CloudFormation Linter"
HOMEPAGE="https://pypi.org/project/cfn-lint/ https://github.com/aws-cloudformation/cfn-python-lint"
SRC_URI="https://github.com/aws-cloudformation/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 x86"

RDEPEND="
	>=dev-python/aws-sam-translator-1.25.0[${PYTHON_USEDEP}]
	$(python_gen_cond_dep '
		dev-python/importlib_resources[${PYTHON_USEDEP}]
	' python3_6)
	dev-python/jsonpatch[${PYTHON_USEDEP}]
	>=dev-python/jsonschema-3.0[${PYTHON_USEDEP}]
	dev-python/junit-xml[${PYTHON_USEDEP}]
	dev-python/networkx[${PYTHON_USEDEP}]
	dev-python/pyyaml[${PYTHON_USEDEP}]
	>=dev-python/requests-2.15.0[${PYTHON_USEDEP}]
	>=dev-python/six-1.11[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/mock[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests --install unittest

PATCHES=(
	"${FILESDIR}/cfn-python-lint-0.30.1-tests.patch"
)

src_prepare() {
	# unpin the deps
	sed -e 's:~=[0-9.]*::' -i setup.py || die
	# requires git checkout
	sed -e 's:test_update_docs:_&:' \
		-i test/unit/module/maintenance/test_update_documentation.py || die
	# requires Internet
	sed -e 's:test_update_resource_specs_python:_&:' \
		-i test/unit/module/maintenance/test_update_resource_specs.py || die
	distutils-r1_src_prepare
}
