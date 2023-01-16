# Copyright 2021-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} )

inherit distutils-r1

DESCRIPTION="Command-line processors for YAML/JSON/Compatible data"
HOMEPAGE="
	https://github.com/wwkimball/yamlpath/
	https://github.com/wwkimball/yamlpath/wiki
"
SRC_URI="
	https://github.com/wwkimball/yamlpath/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="ISC"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-python/ruamel-yaml[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/pytest-console-scripts[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

python_prepare_all() {
	sed -i -e '/ruamel\.yaml/d' setup.py || die

	distutils-r1_python_prepare_all
}

python_test() {
	local EPYTEST_DESELECT=()

	if ! has_version "dev-ruby/hiera-eyaml"; then
		EPYTEST_DESELECT+=(
			tests/test_commands_eyaml_rotate_keys.py
			tests/test_commands_yaml_merge.py::Test_commands_yaml_merge::test_yaml_syntax_error
			tests/test_commands_yaml_paths.py::Test_yaml_paths::test_search_encrypted_values
		)
	fi

	epytest
}
