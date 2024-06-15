# Copyright 2023-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..13} )

inherit distutils-r1

DESCRIPTION="Convert calendars using X-WR-TIMEZONE to standard ones"
HOMEPAGE="
	https://github.com/niccokunzmann/x-wr-timezone/
	https://pypi.org/project/x-wr-timezone/
"
SRC_URI="
	https://github.com/niccokunzmann/x-wr-timezone/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="LGPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"

RDEPEND="
	>=dev-python/icalendar-5.0.11[${PYTHON_USEDEP}]
	dev-python/pytz[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest

EPYTEST_IGNORE=(
	test/test_readme.py
)
