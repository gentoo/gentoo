# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-print/foomatic-gui/foomatic-gui-0.7.9.5-r1.ebuild,v 1.1 2015/03/29 11:41:19 idella4 Exp $

EAPI=5

PYTHON_COMPAT=( python2_7 )
DISTUTILS_SINGLE_IMPL=1
PYTHON_REQ_USE="xml"

inherit distutils-r1

DESCRIPTION="GNOME interface for configuring the Foomatic printer filter system"
HOMEPAGE="http://freshmeat.net/projects/foomatic-gui/"
SRC_URI="mirror://debian/pool/main/f/${PN}/${PN}_${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"
IUSE=""

RDEPEND="
	dev-python/libgnome-python[${PYTHON_USEDEP}]
	dev-python/pygobject:2[${PYTHON_USEDEP}]
	dev-python/libbonobo-python[${PYTHON_USEDEP}]
	dev-python/gnome-vfs-python[${PYTHON_USEDEP}]
	dev-python/ipy[${PYTHON_USEDEP}]
	dev-python/pygtk:2[${PYTHON_USEDEP}]
	dev-python/pywebkitgtk[${PYTHON_USEDEP}]
	net-print/foomatic-db-engine"

S="${WORKDIR}/${PN}"

pkg_setup() {
	python-single-r1_pkg_setup
}
