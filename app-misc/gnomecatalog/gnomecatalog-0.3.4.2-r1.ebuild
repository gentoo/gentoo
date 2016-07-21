# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"
PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE="sqlite,xml"

inherit distutils-r1 eutils fdo-mime gnome2-utils

DESCRIPTION="Cataloging software for CDs and DVDs"
HOMEPAGE="http://gnomecatalog.sf.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	dev-python/gconf-python:2[${PYTHON_USEDEP}]
	dev-python/gnome-vfs-python:2[${PYTHON_USEDEP}]
	dev-python/kaa-metadata[${PYTHON_USEDEP}]
	dev-python/libgnome-python:2[${PYTHON_USEDEP}]
	dev-python/pygobject:2[${PYTHON_USEDEP}]
	>=dev-python/pygtk-2.4:2[${PYTHON_USEDEP}]
	dev-python/pyvorbis[${PYTHON_USEDEP}]
	>=gnome-base/libglade-2:2.0
	>=x11-libs/gtk+-2.4:2
"
DEPEND="${RDEPEND}"

src_prepare() {
	# Fix importing from a single folder in /media
	epatch "${FILESDIR}"/${P}-dbus.patch

	# Use sqlite3 instead of pysqlite2, bug #452126.
	sed -i -e 's:from pysqlite2 import dbapi2:import sqlite3:' \
		gnomecatalog/storage.py || die
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	gnome2_icon_cache_update
	fdo-mime_mime_database_update
}

pkg_postrm() {
	fdo-mime_mime_database_update
	gnome2_icon_cache_update
}
