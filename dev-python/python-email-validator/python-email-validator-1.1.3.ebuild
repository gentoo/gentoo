# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} pypy3 )
inherit distutils-r1

DESCRIPTION="A robust email syntax and deliverability validation library"
HOMEPAGE="https://github.com/JoshData/python-email-validator"
SRC_URI="https://github.com/JoshData/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="CC0-1.0"
KEYWORDS="amd64 arm arm64 ppc ppc64 sparc x86"
SLOT="0"

RDEPEND="
	>=dev-python/idna-2.0.0[${PYTHON_USEDEP}]
	>=dev-python/dnspython-1.15.0[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest

python_test() {
	local deselect=(
		# these tests rely on access to gmail.com
		tests/test_main.py::test_deliverability_no_records
		tests/test_main.py::test_deliverability_found
		tests/test_main.py::test_deliverability_fails
		tests/test_main.py::test_validate_email__with_caching_resolver
		tests/test_main.py::test_validate_email__with_configured_resolver
		# these tests rely on example.com being resolvable
		tests/test_main.py::test_main_single_good_input
		tests/test_main.py::test_main_multi_input
		tests/test_main.py::test_main_input_shim
	)

	epytest ${deselect[@]/#/--deselect }
}
