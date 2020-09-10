# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6..9} )
inherit distutils-r1

DESCRIPTION="Annotate Python AST trees with source text and token information"
HOMEPAGE="
	https://github.com/gristlabs/asttokens/
	https://pypi.org/project/asttokens/"
SRC_URI="
	https://github.com/gristlabs/asttokens/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="dev-python/six[${PYTHON_USEDEP}]"
BDEPEND="
	test? (
		dev-python/astroid[${PYTHON_USEDEP}]
	)"

distutils_enable_tests pytest

export SETUPTOOLS_SCM_PRETEND_VERSION=${PV}

python_test() {
	local deselect=()
	[[ ${EPYTHON} == python3.9 ]] && deselect+=(
		# invalid syntax
		--deselect
		tests/test_astroid.py::TestAstroid::test_fixture9
		--deselect
		tests/test_astroid.py::TestAstroid::test_splat
		--deselect
		tests/test_astroid.py::TestAstroid::test_sys_modules
		--deselect
		tests/test_mark_tokens.py::TestMarkTokens::test_fixture9
		--deselect
		tests/test_mark_tokens.py::TestMarkTokens::test_splat
		--deselect
		tests/test_mark_tokens.py::TestMarkTokens::test_sys_modules
	)
	pytest -vv "${deselect[@]}" || die "Tests failed with ${EPYTHON}"
}
