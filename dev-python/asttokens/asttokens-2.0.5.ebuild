# Copyright 2020-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )
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
KEYWORDS="amd64 arm arm64 ~ppc ~ppc64 ~sparc x86"

RDEPEND="dev-python/six[${PYTHON_USEDEP}]"
BDEPEND="
	dev-python/setuptools_scm[${PYTHON_USEDEP}]
	dev-python/toml[${PYTHON_USEDEP}]
	test? (
		dev-python/astroid[${PYTHON_USEDEP}]
	)"

distutils_enable_tests pytest

export SETUPTOOLS_SCM_PRETEND_VERSION=${PV}

python_test() {
	local deselect=()
	[[ ${EPYTHON} == python3.8 ]] && deselect+=(
		tests/test_astroid.py::TestAstroid::test_slices
	)

	epytest ${deselect[@]/#/--deselect }
}
