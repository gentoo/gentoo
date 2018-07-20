# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 )

inherit autotools fdo-mime gnome2-utils python-single-r1

DESCRIPTION="A graphical front-end for the gschem -> pcb workflow"
HOMEPAGE="http://www.gpleda.org"
SRC_URI="http://geda.seul.org/dist/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"

IUSE="gnome nls"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

CDEPEND="${PYTHON_DEPS}
	dev-python/pygtk:2[${PYTHON_USEDEP}]
	dev-python/pygobject:2[${PYTHON_USEDEP}]
	dev-python/dbus-python[${PYTHON_USEDEP}]
	sci-electronics/pcb[dbus]
	sci-electronics/geda
	nls? ( virtual/libintl )
"
RDEPEND="${CDEPEND}
	sci-electronics/electronics-menu
	gnome? ( dev-python/gnome-vfs-python[${PYTHON_USEDEP}] )
"
DEPEND="${CDEPEND}
	dev-util/intltool
	dev-lang/perl
	nls? ( sys-devel/gettext )
"

PATCHES=( "${FILESDIR}"/${PV}-python.patch )

pkg_setup() {
	python-single-r1_pkg_setup
}

src_prepare(){
	default
	eautoreconf
}

src_configure() {
	econf \
		$(use_enable nls) \
		--disable-update-desktop-database
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update
	gnome2_icon_cache_update
}

pkg_postrm() {
	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update
	gnome2_icon_cache_update
}
