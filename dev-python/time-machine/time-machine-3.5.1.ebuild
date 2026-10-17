# Copyright 2022-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{12..15} python3_{14..15}t )

inherit distutils-r1 toolchain-funcs

DESCRIPTION="Travel through time in your tests"
HOMEPAGE="
	https://github.com/adamchainz/time-machine/
	https://pypi.org/project/time-machine/
"
SRC_URI="
	https://github.com/adamchainz/time-machine/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~arm64 ~hppa ~loong ~m68k ~mips ~ppc ppc64 ~riscv ~s390 ~sparc ~x86"

BDEPEND="
	test? (
		dev-python/freezegun[${PYTHON_USEDEP}]
		dev-python/python-dateutil[${PYTHON_USEDEP}]
		dev-python/tokenize-rt[${PYTHON_USEDEP}]
	)
"

EPYTEST_PLUGIN_LOAD_VIA_ENV=1
EPYTEST_PLUGINS=( "${PN}" hypothesis )
distutils_enable_tests pytest

src_test() {
	local EPYTEST_DESELECT=()

	if ! tc-has-64bit-time_t; then
		EPYTEST_DESELECT+=(
			tests/test_fuzz.py::test_travel_to_aware_datetime
			tests/test_fuzz.py::TestTravelMachine::runTest
			tests/test_time_machine.py::test_datetime_today_exact_far_future
			tests/test_time_machine.py::test_datetime_today_subclass_exact_far_future
			tests/test_time_machine.py::test_date_today_exact_far_future
		)
	fi

	distutils-r1_src_test
}
