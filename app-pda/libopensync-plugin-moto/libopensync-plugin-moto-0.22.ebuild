# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-pda/libopensync-plugin-moto/libopensync-plugin-moto-0.22.ebuild,v 1.4 2012/04/01 04:38:26 floppym Exp $

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
