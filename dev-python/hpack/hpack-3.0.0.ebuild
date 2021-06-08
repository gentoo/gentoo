# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{7..10} )

inherit distutils-r1

DESCRIPTION="Pure-Python HPACK header compression"
HOMEPAGE="
	https://python-hyper.org/hpack/en/latest/
	https://pypi.org/project/hpack/"
SRC_URI="https://github.com/python-hyper/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~mips ppc ppc64 ~riscv ~s390 sparc x86"

# dev-python/pytest-relaxed causes tests to fail
BDEPEND="
	test? (
		>=dev-python/hypothesis-3.4.2[${PYTHON_USEDEP}]
		!!dev-python/pytest-relaxed[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

PATCHES=(
	"${FILESDIR}"/hpack-3.0.0-hypothesis-healthcheck.patch
)

python_test() {
	local deselect=(
		# relies on outdated exception strings
		test/test_table.py::TestHeaderTable::test_get_by_index_out_of_range
	)

	epytest hpack test ${deselect[@]/#/--deselect }
}
