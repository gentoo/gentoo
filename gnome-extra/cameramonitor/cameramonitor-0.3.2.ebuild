# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-extra/cameramonitor/cameramonitor-0.3.2.ebuild,v 1.2 2014/08/10 21:19:30 slyfox Exp $

EAPI="5"
GCONF_DEBUG="no"
PYTHON_DEPEND="2"
RESTRICT_PYTHON_ABIS="3.*"

inherit gnome2 python autotools

DESCRIPTION="Local Webcam monitoring in system tray"
HOMEPAGE="https://launchpad.net/cameramonitor"
SRC_URI="https://launchpad.net/${PN}/trunk/${PV}/+download/${P}.tar.bz2"
LICENSE="GPL-2"
SLOT="0"

KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-python/gconf-python:2
		dev-python/notify-python
		dev-python/pyinotify
		dev-python/dbus-python"

DEPEND="${RDEPEND}"

DOCS="AUTHORS ChangeLog NEWS README TODO"

pkg_setup() {
	python_set_active_version 2
	python_pkg_setup
}

src_prepare() {
	python_clean_py-compile_files

	eautoreconf

	gnome2_src_prepare
}

pkg_postinst() {
	gnome2_pkg_postinst
	python_mod_optimize cameramonitor
}

pkg_postrm() {
	gnome2_pkg_postrm
	python_mod_cleanup cameramonitor
}
