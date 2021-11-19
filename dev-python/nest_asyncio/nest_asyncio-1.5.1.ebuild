# Copyright 2020-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )

inherit distutils-r1

DESCRIPTION="Patch asyncio to allow nested event loops"
HOMEPAGE="https://github.com/erdewit/nest_asyncio/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="amd64 arm arm64 hppa ~ia64 ppc ppc64 ~riscv ~s390 sparc x86"

distutils_enable_tests pytest

python_test() {
	local deselect=()
	[[ ${EPYTHON} == python3.10 ]] && deselect+=(
		# incorrect args in test itself
		tests/nest_test.py::NestTest::test_two_run_until_completes_in_one_outer_loop
	)
	epytest ${deselect[@]/#/--deselect }
}
