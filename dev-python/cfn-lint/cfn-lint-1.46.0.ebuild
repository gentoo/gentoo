# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..13} )

inherit distutils-r1 pypi

DESCRIPTION="CloudFormation Linter"
HOMEPAGE="
	https://github.com/aws-cloudformation/cfn-lint/
	https://pypi.org/project/cfn-lint/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~riscv ~x86"

RDEPEND="
	>=dev-python/aws-sam-translator-1.97.0[${PYTHON_USEDEP}]
	dev-python/jsonpatch[${PYTHON_USEDEP}]
	>=dev-python/jschema-to-python-1.2.3[${PYTHON_USEDEP}]
	<dev-python/jsonschema-5[${PYTHON_USEDEP}]
	>=dev-python/jsonschema-3.0[${PYTHON_USEDEP}]
	dev-python/junit-xml[${PYTHON_USEDEP}]
	<dev-python/networkx-4[${PYTHON_USEDEP}]
	>=dev-python/pyyaml-5.4[${PYTHON_USEDEP}]
	>=dev-python/regex-2021.7.1[${PYTHON_USEDEP}]
	>=dev-python/sarif-om-1.0.4[${PYTHON_USEDEP}]
	>=dev-python/sympy-1.0.0[${PYTHON_USEDEP}]
"
BDEPEND="
	>=dev-python/setuptools-77.0.3[${PYTHON_USEDEP}]
	test? (
		dev-python/defusedxml[${PYTHON_USEDEP}]
	)
"

EPYTEST_PLUGINS=()
distutils_enable_tests pytest

python_test() {
	local EPYTEST_DESELECT=(
		# different line wrapping somehow
		test/unit/module/template/test_template.py::TestTemplate::test_build_graph
		# requires git repo
		test/unit/module/maintenance/test_update_documentation.py::TestUpdateDocumentation::test_update_docs
		# TODO: suddenly started failing in older versions too
		# https://github.com/aws-cloudformation/cfn-lint/issues/4207
		test/integration/test_good_templates.py
		test/unit/module/override/test_exclude.py::TestExclude::test_success_run
		test/unit/module/test_api.py::TestLintFile::test_good_template
		test/unit/module/test_rules_collections.py::TestRulesCollection::test_success_run
	)

	# from tox.ini
	local -x AWS_DEFAULT_REGION=us-east-1
	epytest
}
