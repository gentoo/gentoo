# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} pypy3 )
PYTHON_REQ_USE="threads(+)"

inherit distutils-r1

DESCRIPTION="Automatically formats Python code to conform to the PEP 8 style guide"
HOMEPAGE="
	https://github.com/hhatto/autopep8/
	https://pypi.org/project/autopep8/
"
if [[ ${PV} == *9999* ]]; then
	EGIT_REPO_URI="https://github.com/hhatto/${PN}.git"
	inherit git-r3
else
	SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"
	KEYWORDS="~alpha amd64 ~arm64 ~ia64 ppc sparc x86 ~amd64-linux ~x86-linux"
fi

LICENSE="MIT"
SLOT="0"

RDEPEND="
	>=dev-python/pycodestyle-2.10[${PYTHON_USEDEP}]
	$(python_gen_cond_dep '
		dev-python/tomli[${PYTHON_USEDEP}]
	' 3.{8..10})
"

distutils_enable_tests pytest

python_test() {
	local EPYTEST_DESELECT=()

	[[ ${EPYTHON} == python3.11 ]] && EPYTEST_DESELECT+=(
		# fails due to deprecation warnings
		test/test_autopep8.py::CommandLineTests::test_in_place_no_modifications_no_writes
		test/test_autopep8.py::CommandLineTests::test_in_place_no_modifications_no_writes_with_empty_file
	)

	epytest
}
