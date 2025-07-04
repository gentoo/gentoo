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
	>=dev-python/click-3.2[${PYTHON_USEDEP}]
	>=dev-python/click-log-0.2.0[${PYTHON_USEDEP}]
	>=dev-python/icalendar-6.0[${PYTHON_USEDEP}]
	>=dev-python/urwid-2.6.15[${PYTHON_USEDEP}]
	dev-python/pyxdg[${PYTHON_USEDEP}]
	dev-python/pytz[${PYTHON_USEDEP}]
	dev-python/python-dateutil[${PYTHON_USEDEP}]
	dev-python/configobj[${PYTHON_USEDEP}]
	>=dev-python/tzlocal-1.0[${PYTHON_USEDEP}]
	dev-python/setproctitle[${PYTHON_USEDEP}]
"
BDEPEND="
	>=dev-python/setuptools-scm-8[${PYTHON_USEDEP}]
	test? (
		dev-python/pytest[${PYTHON_USEDEP}]
		dev-python/freezegun[${PYTHON_USEDEP}]
		dev-python/hypothesis[${PYTHON_USEDEP}]
		dev-python/packaging[${PYTHON_USEDEP}]
		dev-python/vdirsyncer[${PYTHON_USEDEP}]
	)
"

DOCS=( AUTHORS.txt CHANGELOG.rst CONTRIBUTING.rst README.rst khal.conf.sample )

distutils_enable_tests pytest
