# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="6"

PYTHON_COMPAT=( python3_4 )

inherit eutils python-r1 distutils-r1

MY_PN="Nagstamon"
MY_P="${MY_PN}-${PV/_}"

DESCRIPTION="status monitor for the desktop"
HOMEPAGE="http://nagstamon.sourceforge.net"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

# TODO: secretstorage
# TODO: Xlib - https://github.com/python-xlib/python-xlib/tree/master/Xlib
RDEPEND="dev-python/PyQt5[gui,multimedia,svg,widgets]
	dev-python/beautifulsoup:4
	dev-python/dbus-python
	dev-python/keyring
	dev-python/requests
	dev-python/psutil
	dev-python/setuptools"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${MY_PN}"

PATCHES="${FILESDIR}/${P}-setup.patch"

src_prepare() {
	default_src_prepare

	mv ${PN}.py ${PN} || die

#	rm -rf "${S}/Nagstamon/thirdparty/Xlib/" || die
	rm -rf "${S}/Nagstamon/thirdparty/keyring/" || die
}

pkg_preinst() {
	if has_version "<net-analyzer/nagstamon-2.0"; then
		OLD_NAGSTAMON_VERSION=yup
	fi
}

pkg_postinst() {
	if [ -n "${OLD_NAGSTAMON_VERSION}" ]; then
		ewarn "WARNING: It is recommend to move your old Nagstamon 1.x ~/.nagstamon/ away and start from scratch!"
	fi
}
