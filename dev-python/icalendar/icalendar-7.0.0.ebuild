# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( python3_{11..14} )

inherit distutils-r1 pypi

DESCRIPTION="RFC 5545 compatible parser and generator of iCalendar files"
HOMEPAGE="
	https://github.com/collective/icalendar/
	https://pypi.org/project/icalendar/
"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~riscv ~x86"

RDEPEND="
	dev-python/python-dateutil[${PYTHON_USEDEP}]
	dev-python/tzdata[${PYTHON_USEDEP}]
"
BDEPEND="
	dev-python/hatch-vcs[${PYTHON_USEDEP}]
	test? (
		>=dev-python/pytz-2025.2[${PYTHON_USEDEP}]
		$(python_gen_cond_dep '
			>=dev-python/typing-extensions-4.10[${PYTHON_USEDEP}]
		' 3.11 3.12)
	)
"

EPYTEST_PLUGINS=( hypothesis )
distutils_enable_tests pytest

EPYTEST_IGNORE=(
	# upstream puts quite an effort for funding.json, but failed to
	# include it in sdist
	src/icalendar/tests/test_funding_json.py
)
