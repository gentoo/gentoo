# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10,11} )
DISTUTILS_USE_PEP517=setuptools

inherit distutils-r1

distutils_enable_tests pytest

MY_PN="Nagstamon"
MY_P="${MY_PN}-${PV/_p/-}"

DESCRIPTION="status monitor for the desktop"
DESCRIPTION="systray monitor for displaying realtime status of several monitoring systems"
HOMEPAGE="https://nagstamon.de"
SRC_URI="https://github.com/HenriWahl/Nagstamon/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="test"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="${PYTHON_DEPS}
	dev-python/lxml[${PYTHON_USEDEP}]
	|| (
	   dev-python/PyQt6[gui,multimedia,svg,widgets,${PYTHON_USEDEP}]
	   dev-python/PyQt5[gui,multimedia,svg,widgets,${PYTHON_USEDEP}]
	   )
	dev-python/PySocks[${PYTHON_USEDEP}]
	dev-python/beautifulsoup4[${PYTHON_USEDEP}]
	dev-python/dbus-python[${PYTHON_USEDEP}]
	dev-python/keyring[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
	dev-python/psutil[${PYTHON_USEDEP}]
	dev-python/python-dateutil[${PYTHON_USEDEP}]
	dev-python/cryptography[${PYTHON_USEDEP}]
	dev-python/secretstorage[${PYTHON_USEDEP}]
	>=dev-python/python-xlib-0.19[${PYTHON_USEDEP}]
	dev-python/requests-kerberos[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? ( dev-python/pylint[${PYTHON_USEDEP}] )"

S="${WORKDIR}/${MY_P}"

PATCHES=( "${FILESDIR}/${PN}-3.12.0-setup.patch" )

src_prepare() {
	default_src_prepare

	# pre-compressed already
	rm Nagstamon/resources/nagstamon.1.gz || die
	sed -i -e 's:\(nagstamon\.1\)\.gz:\1:' setup.py || die

	mv ${PN}.py ${PN} || die

	rm -rf "${S}/Nagstamon/thirdparty/Xlib/" || die
}
