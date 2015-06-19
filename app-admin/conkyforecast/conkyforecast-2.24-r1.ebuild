# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-admin/conkyforecast/conkyforecast-2.24-r1.ebuild,v 1.1 2014/12/14 23:16:01 mgorny Exp $

EAPI=5

# upstream broke setup.py to install into /usr/share...
DISTUTILS_SINGLE_IMPL=1
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Conky weather forecast script with support for language files"
HOMEPAGE="https://launchpad.net/~conky-companions"
SRC_URI="https://launchpad.net/~conky-companions/+archive/ppa/+files/${PN}_${PV}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="app-admin/conky"

S=${WORKDIR}/src

python_prepare_all() {
	sed -i -e "s:pythoncmd=.*$:pythoncmd=${EPYTHON}:" conkyForecast* || die

	distutils-r1_python_prepare_all
}

python_install() {
	distutils-r1_python_install

	python_optimize "${ED%/}"/usr/share/${PN}
}

pkg_postinst() {
	elog "You have to define a partner id and registration code for "
	elog "the weather.com xoap. You need to copy the template from"
	elog "/usr/share/conkyforecast/conkyForecast.config into you account"
	elog "as ~/.conkyForecast.config and edit the respective fields."
	elog
	elog "More details can be found in the README file."
}
