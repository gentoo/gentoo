# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

PYTHON_COMPAT=( python3_4 )

inherit eutils python-r1 distutils-r1

MY_PN="Nagstamon"
MY_P="${MY_PN}-${PV/_}"

DESCRIPTION="Nagstamon is a systray monitor for displaying realtime status of a Nagios box"
HOMEPAGE="http://nagstamon.sourceforge.net"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

# TODO: secretstorage
# TODO: Xlib - https://github.com/python-xlib/python-xlib/tree/master/Xlib
RDEPEND="${PYTHON_DEPS}
	dev-python/PyQt5[gui,multimedia,svg,widgets,${PYTHON_USEDEP}]
	dev-python/beautifulsoup:4[${PYTHON_USEDEP}]
	dev-python/dbus-python[${PYTHON_USEDEP}]
	dev-python/keyring[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
	dev-python/psutil[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]"

S="${WORKDIR}/${MY_PN}"

PATCHES="${FILESDIR}/${PN}-2.0-setup.patch"

src_prepare() {
	default

	mv ${PN}.py ${PN} || die

#	rm -rf "${S}/Nagstamon/thirdparty/Xlib/" || die
	rm -rf "${S}/Nagstamon/thirdparty/keyring/" || die
}
