# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/xesam-tools/xesam-tools-0.7.0-r1.ebuild,v 1.1 2015/02/22 07:01:00 idella4 Exp $

EAPI=5

PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE="xml"
DISTUTILS_SINGLE_IMPL=1

inherit distutils-r1

DESCRIPTION="Development tools and examples for the Xesam desktop search API"
HOMEPAGE="http://xesam.org/people/kamstrup/xesam-tools"
SRC_URI="http://xesam.org/people/kamstrup/${PN}/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="examples"

DEPEND=""
RDEPEND="dev-python/dbus-python[${PYTHON_USEDEP}]
	dev-python/pygobject:2[${PYTHON_USEDEP}]
	dev-python/pygtk[${PYTHON_USEDEP}]"

pkg_setup() {
	python-single-r1_pkg_setup
}

src_install() {
	distutils-r1_src_install

	insinto "/usr/share/doc/${PF}"
	doins -r samples

	if use examples; then
		insinto "/usr/share/doc/${PF}/demo"
		doins "demo/demo.py"
		insopts -m 0755
		doins demo/[^d]*
	fi
}
