# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=3

PYTHON_DEPEND="2:2.6"

inherit multilib python

DESCRIPTION="Motorola plug-in for OpenSync"
HOMEPAGE="http://www.opensync.org/"
SRC_URI="http://www.opensync.org/download/releases/${PV}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="bluetooth"

RDEPEND="~app-pda/libopensync-${PV}
	~app-pda/libopensync-plugin-python-${PV}
	dev-python/python-dateutil
	bluetooth? ( dev-python/pybluez )"
DEPEND=""

src_install() {
	# This is correct per README and OPENSYNC_PYTHONPLG_DIR variable in
	# configure.in at libopensync-plugin-python-0.22 package.
	insinto /usr/$(get_libdir)/opensync/python-plugins
	doins motosync.py || die
	exeinto /usr/share/opensync/defaults
	doexe moto-sync || die
	dodoc AUTHORS README
}
