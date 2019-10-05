# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

PYTHON_COMPAT=( python3_{5,6} )
PYTHON_REQ_USE="sqlite"

inherit distutils-r1

DESCRIPTION="A CalDAV based calendar"
HOMEPAGE="http://lostpackets.de/khal/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
KEYWORDS="~amd64 ~x86"
SLOT="0"
IUSE="zsh-completion"

RDEPEND=">=dev-python/click-3.2[${PYTHON_USEDEP}]
	>=dev-python/click-log-0.2.0[${PYTHON_USEDEP}]
	>=dev-python/icalendar-4.0.3[${PYTHON_USEDEP}]
	dev-python/urwid[${PYTHON_USEDEP}]
	dev-python/pyxdg[${PYTHON_USEDEP}]
	dev-python/pytz[${PYTHON_USEDEP}]
	<=dev-python/python-dateutil-2.6.1[${PYTHON_USEDEP}]
	dev-python/configobj[${PYTHON_USEDEP}]
	>=dev-python/atomicwrites-0.1.7[${PYTHON_USEDEP}]
	>=dev-python/tzlocal-1.0[${PYTHON_USEDEP}]
	dev-python/setproctitle[${PYTHON_USEDEP}]
	zsh-completion? ( app-shells/zsh )"
DEPEND=">dev-python/setuptools_scm-1.12.0[${PYTHON_USEDEP}]
	dev-python/vdirsyncer[${PYTHON_USEDEP}]
	dev-python/freezegun[${PYTHON_USEDEP}]"

DOCS=( AUTHORS.txt CHANGELOG.rst CONTRIBUTING.rst README.rst khal.conf.sample )

src_install() {
	distutils-r1_src_install
	if use zsh-completion; then
		insinto /usr/share/zsh/site-functions
		doins misc/__khal
	fi
}
