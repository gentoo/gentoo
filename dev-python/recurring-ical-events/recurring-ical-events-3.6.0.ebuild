# Copyright 2023-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( python3_{10..13} )

inherit distutils-r1 pypi

DESCRIPTION="Repeat ICalendar events by RRULE, RDATE and EXDATE"
HOMEPAGE="
	https://github.com/niccokunzmann/python-recurring-ical-events/
	https://pypi.org/project/recurring-ical-events/
"

LICENSE="LGPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"

RDEPEND="
	<dev-python/icalendar-7[${PYTHON_USEDEP}]
	>=dev-python/icalendar-6.1.0[${PYTHON_USEDEP}]
	<dev-python/python-dateutil-3[${PYTHON_USEDEP}]
	>=dev-python/python-dateutil-2.8.1[${PYTHON_USEDEP}]
	<dev-python/x-wr-timezone-3[${PYTHON_USEDEP}]
	>=dev-python/x-wr-timezone-1.0.0[${PYTHON_USEDEP}]
"
BDEPEND="
	dev-python/hatch-vcs[${PYTHON_USEDEP}]
	test? (
		>=dev-python/pytz-2023.3[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

EPYTEST_IGNORE=(
	test/test_readme.py
)
