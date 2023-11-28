# Copyright 2022-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=poetry
PYTHON_COMPAT=( pypy3 python3_{10..12} )

inherit distutils-r1

DESCRIPTION="Drop-in replacement for the standard datetime class"
HOMEPAGE="
	https://pendulum.eustace.io/
	https://github.com/sdispater/pendulum/
	https://pypi.org/project/pendulum/
"
SRC_URI="
	https://github.com/sdispater/pendulum/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 arm arm64 ~hppa ~ia64 ~loong ~ppc ppc64 ~riscv ~s390 ~sparc x86"

DEPEND="
	dev-python/python-dateutil[${PYTHON_USEDEP}]
	dev-python/pytzdata[${PYTHON_USEDEP}]
"
RDEPEND="
	${DEPEND}
"
BDEPEND="
	test? (
		dev-python/Babel[${PYTHON_USEDEP}]
		dev-python/freezegun[${PYTHON_USEDEP}]
		dev-python/pytz[${PYTHON_USEDEP}]
	)
"

EPYTEST_DESELECT=(
	# sigh
	tests/datetime/test_behavior.py::test_proper_dst
	tests/tz/test_timezone.py::test_dst
)

distutils_enable_tests pytest
