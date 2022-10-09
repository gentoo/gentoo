# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..11} pypy3 )

inherit distutils-r1

DESCRIPTION="A robust email syntax and deliverability validation library"
HOMEPAGE="
	https://github.com/JoshData/python-email-validator/
	https://pypi.org/project/email-validator/
"
SRC_URI="
	https://github.com/JoshData/python-email-validator/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="CC0-1.0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"
SLOT="0"

RDEPEND="
	>=dev-python/idna-2.8[${PYTHON_USEDEP}]
	>=dev-python/dnspython-1.15.0[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest

EPYTEST_DESELECT=(
	# these tests rely on access to gmail.com
	tests/test_main.py::test_deliverability_found
	tests/test_main.py::test_deliverability_fails
	# these tests rely on example.com being resolvable
	"tests/test_main.py::test_email_example_reserved_domain[me@mail.example]"
	"tests/test_main.py::test_email_example_reserved_domain[me@example.com]"
	"tests/test_main.py::test_email_example_reserved_domain[me@mail.example.com]"
	tests/test_main.py::test_validate_email__with_caching_resolver
	tests/test_main.py::test_main_single_good_input
	tests/test_main.py::test_main_multi_input
	tests/test_main.py::test_main_input_shim
)
