# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..10} )

inherit distutils-r1

DESCRIPTION="CloudFormation Linter"
HOMEPAGE="
	https://github.com/aws-cloudformation/cfn-lint/
	https://pypi.org/project/cfn-lint/
"
SRC_URI="
	https://github.com/aws-cloudformation/cfn-lint/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~riscv ~x86"

RDEPEND="
	>=dev-python/aws-sam-translator-1.51.0[${PYTHON_USEDEP}]
	dev-python/jsonpatch[${PYTHON_USEDEP}]
	>=dev-python/jschema_to_python-1.2.3[${PYTHON_USEDEP}]
	>=dev-python/jsonschema-3.0[${PYTHON_USEDEP}]
	dev-python/junit-xml[${PYTHON_USEDEP}]
	dev-python/networkx[${PYTHON_USEDEP}]
	>dev-python/pyyaml-5.4[${PYTHON_USEDEP}]
	>=dev-python/requests-2.15.0[${PYTHON_USEDEP}]
	>=dev-python/sarif_om-1.0.4[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest

EPYTEST_DESELECT=(
	# TODO
	test/unit/module/test_template.py::TestTemplate::test_build_graph
	# requires git repo
	test/unit/module/maintenance/test_update_documentation.py::TestUpdateDocumentation::test_update_docs
	# Internet
	test/unit/module/formatters/test_formatters.py::TestFormatters::test_sarif_formatter
	test/unit/module/maintenance/test_update_resource_specs.py::TestUpdateResourceSpecs::test_update_resource_specs_python_2
	test/unit/module/maintenance/test_update_resource_specs.py::TestUpdateResourceSpecs::test_update_resource_specs_python_3
)

src_prepare() {
	# unpin the deps
	sed -e 's:~=[0-9.]*::' -i setup.py || die
	distutils-r1_src_prepare
}
