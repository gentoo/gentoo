# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} )

inherit distutils-r1

DESCRIPTION="Package used for parsing and generating iCalendar files (RFC 2445)"
HOMEPAGE="
	https://github.com/collective/icalendar/
	https://pypi.org/project/icalendar/
"
SRC_URI="mirror://pypi/${P::1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~riscv x86"

RDEPEND="
	dev-python/python-dateutil[${PYTHON_USEDEP}]
	dev-python/pytz[${PYTHON_USEDEP}]
	$(python_gen_cond_dep '
		dev-python/backports-zoneinfo[${PYTHON_USEDEP}]
	' 3.8)
"
BDEPEND="
	test? (
		dev-python/hypothesis[${PYTHON_USEDEP}]
	)
"

distutils_enable_sphinx docs
distutils_enable_tests pytest

python_prepare_all() {
	# reset conf.py to not read version from an installed instance
	sed -e "s:pkg_resources.get_distribution('icalendar').version:'${PV}':" \
		-i docs/conf.py || die
	distutils-r1_python_prepare_all
}
