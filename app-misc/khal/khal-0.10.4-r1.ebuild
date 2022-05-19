# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )
PYTHON_REQ_USE="sqlite"

inherit distutils-r1

DESCRIPTION="A CalDAV based calendar"
HOMEPAGE="https://lostpackets.de/khal/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~riscv ~x86"

RDEPEND="dev-python/click[${PYTHON_USEDEP}]
	dev-python/click-log[${PYTHON_USEDEP}]
	>=dev-python/icalendar-4.0.3[${PYTHON_USEDEP}]
	>=dev-python/urwid-1.3.0[${PYTHON_USEDEP}]
	dev-python/pyxdg[${PYTHON_USEDEP}]
	dev-python/pytz[${PYTHON_USEDEP}]
	dev-python/python-dateutil[${PYTHON_USEDEP}]
	dev-python/configobj[${PYTHON_USEDEP}]
	>=dev-python/atomicwrites-0.1.7[${PYTHON_USEDEP}]
	dev-python/tzlocal[${PYTHON_USEDEP}]
	dev-python/setproctitle[${PYTHON_USEDEP}]"
BDEPEND=">dev-python/setuptools_scm-1.12.0[${PYTHON_USEDEP}]
	dev-python/vdirsyncer[${PYTHON_USEDEP}]
	dev-python/freezegun[${PYTHON_USEDEP}]"

# https://github.com/pimutils/khal/issues/793
PATCHES=( "${FILESDIR}/${P}-add-etag.patch" )
DOCS=( AUTHORS.txt CHANGELOG.rst CONTRIBUTING.rst README.rst khal.conf.sample )

distutils_enable_tests pytest

src_install() {
	distutils-r1_src_install

	insinto /usr/share/zsh/site-functions
	doins misc/__khal
}
