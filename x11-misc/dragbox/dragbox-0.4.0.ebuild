# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4
PYTHON_DEPEND="2"
inherit python

DESCRIPTION="GTK tool for connecting the commandline with the desktop environment"
HOMEPAGE="http://kaizer.se/wiki/dragbox/"
SRC_URI="http://kaizer.se/publicfiles/${PN}/${P}.tar.gz"
LICENSE="GPL-2"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-python/pygtk:2
	gnome-base/libglade:2.0
	dev-python/gnome-vfs-python:2
	dev-python/libgnome-python:2
	dev-python/gconf-python:2
	sys-apps/dbus
	x11-libs/gtk+:2"
RDEPEND="${DEPEND}"

pkg_setup() {
	python_set_active_version 2
	python_pkg_setup
}

src_prepare() {
	python_clean_py-compile_files
	python_convert_shebangs 2 dragbox
}

src_install() {
	emake DESTDIR="${D}" install
	dodoc AUTHORS ChangeLog NEWS README TODO
}

pkg_postinst() {
	python_mod_optimize Dragbox
}

pkg_postrm() {
	python_mod_cleanup Dragbox
}
