# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..10} )

inherit distutils-r1

DESCRIPTION="CalDAV (RFC4791) client library for Python"
HOMEPAGE="
	https://github.com/python-caldav/caldav
	https://pypi.org/project/caldav/
"
SRC_URI="
	https://github.com/python-caldav/caldav/archive/refs/tags/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="|| ( GPL-3 Apache-2.0 )"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-python/lxml[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
	dev-python/vobject[${PYTHON_USEDEP}]
"
# For now, really does use nose imports: bug #857738
BDEPEND="
	test? (
		dev-python/nose[${PYTHON_USEDEP}]
		dev-python/icalendar[${PYTHON_USEDEP}]
		dev-python/tzlocal[${PYTHON_USEDEP}]
		dev-python/pytz[${PYTHON_USEDEP}]
		www-apps/radicale[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest
