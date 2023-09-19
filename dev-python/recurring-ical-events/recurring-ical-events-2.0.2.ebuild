# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1

MY_P=python-${P}
DESCRIPTION="Repeat ICalendar events by RRULE, RDATE and EXDATE"
HOMEPAGE="
	https://github.com/niccokunzmann/python-recurring-ical-events/
	https://pypi.org/project/recurring-ical-events/
"
SRC_URI="
	https://github.com/niccokunzmann/python-recurring-ical-events/archive/v${PV}.tar.gz
		-> ${MY_P}.gh.tar.gz
"
S=${WORKDIR}/${MY_P}

LICENSE="LGPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"

RDEPEND="
	dev-python/icalendar[${PYTHON_USEDEP}]
	>=dev-python/python-dateutil-2.8.1[${PYTHON_USEDEP}]
	dev-python/pytz[${PYTHON_USEDEP}]
	<dev-python/x-wr-timezone-1.0.0[${PYTHON_USEDEP}]
	>=dev-python/x-wr-timezone-0.0.5[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest

EPYTEST_IGNORE=(
	test/test_readme.py
)

EPYTEST_DESELECT=(
	# a test checking if tzdata package is installed that is apparently
	# needed for other tests, except it isn't
	test/test_zoneinfo_issue_57.py::test_zoneinfo_must_be_installed_if_it_is_possible
)
