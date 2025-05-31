# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..13} )
PYTHON_REQ_USE="sqlite"

inherit distutils-r1 pypi

DESCRIPTION="A CalDAV based calendar"
HOMEPAGE="https://lostpackets.de/khal/ https://github.com/pimutils/khal"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~riscv ~x86"

RDEPEND="
	dev-python/click[${PYTHON_USEDEP}]
	dev-python/click-log[${PYTHON_USEDEP}]
	dev-python/icalendar[${PYTHON_USEDEP}]
	dev-python/urwid[${PYTHON_USEDEP}]
	dev-python/pyxdg[${PYTHON_USEDEP}]
	dev-python/pytz[${PYTHON_USEDEP}]
	dev-python/python-dateutil[${PYTHON_USEDEP}]
	dev-python/configobj[${PYTHON_USEDEP}]
	dev-python/atomicwrites[${PYTHON_USEDEP}]
	dev-python/tzlocal[${PYTHON_USEDEP}]
	dev-python/setproctitle[${PYTHON_USEDEP}]
"
BDEPEND="
	dev-python/setuptools-scm[${PYTHON_USEDEP}]
	test? (
		dev-python/freezegun[${PYTHON_USEDEP}]
		dev-python/hypothesis[${PYTHON_USEDEP}]
		dev-python/packaging[${PYTHON_USEDEP}]
		dev-python/vdirsyncer[${PYTHON_USEDEP}]
	)
"

DOCS=( AUTHORS.txt CHANGELOG.rst CONTRIBUTING.rst README.rst khal.conf.sample )

distutils_enable_tests pytest
