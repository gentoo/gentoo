# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYPI_NO_NORMALIZE=1
PYTHON_COMPAT=( python3_{10..11} )

inherit distutils-r1 pypi

DESCRIPTION="CloudFormation Linter"
HOMEPAGE="
	https://github.com/aws-cloudformation/cfn-lint/
	https://pypi.org/project/cfn-lint/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~riscv x86"

RDEPEND="
	>=dev-python/aws-sam-translator-1.79.0[${PYTHON_USEDEP}]
	dev-python/jsonpatch[${PYTHON_USEDEP}]
	>=dev-python/jschema-to-python-1.2.3[${PYTHON_USEDEP}]
	<dev-python/jsonschema-5[${PYTHON_USEDEP}]
	>=dev-python/jsonschema-3.0[${PYTHON_USEDEP}]
	dev-python/junit-xml[${PYTHON_USEDEP}]
	<dev-python/networkx-4[${PYTHON_USEDEP}]
	>dev-python/pyyaml-5.4[${PYTHON_USEDEP}]
	>=dev-python/requests-2.15.0[${PYTHON_USEDEP}]
	>=dev-python/regex-2021.7.1[${PYTHON_USEDEP}]
	>=dev-python/sarif-om-1.0.4[${PYTHON_USEDEP}]
	>=dev-python/sympy-1.0.0[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest

src_prepare() {
	# unpin the deps
	sed -e 's:~=[0-9.]*::' -i setup.py || die
	distutils-r1_src_prepare
}

python_test() {
	local EPYTEST_DESELECT=(
		# TODO
		test/unit/module/test_template.py::TestTemplate::test_build_graph
		# requires git repo
		test/unit/module/maintenance/test_update_documentation.py::TestUpdateDocumentation::test_update_docs
		# Internet
		test/unit/module/formatters/test_formatters.py::TestFormatters::test_sarif_formatter
		test/unit/module/maintenance/test_update_resource_specs.py::TestUpdateResourceSpecs::test_update_resource_specs_python_3
		# TODO: it looks as if AWS_DEFAULT_REGION didn't work
		test/unit/module/core/test_run_cli.py::TestCli::test_bad_config
		test/unit/module/core/test_run_cli.py::TestCli::test_override_parameters
		test/unit/module/core/test_run_cli.py::TestCli::test_positional_template_parameters
		test/unit/module/core/test_run_cli.py::TestCli::test_template_config
	)

	# from tox.ini
	local -x AWS_DEFAULT_REGION=us-east-1
	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	epytest
}
