# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="3"

WANT_AUTOCONF="2.5"
PYTHON_DEPEND="2"

inherit autotools eutils fdo-mime gnome2-utils python

DESCRIPTION="A graphical front-end for the gschem -> pcb workflow"
HOMEPAGE="http://www.gpleda.org"
SRC_URI="http://geda.seul.org/dist/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="gnome nls"

CDEPEND="
	dev-python/pygtk:2
	dev-python/pygobject:2
	dev-python/dbus-python
	sci-electronics/pcb[dbus]
	sci-electronics/geda
	nls? ( virtual/libintl )"

RDEPEND="
	${CDEPEND}
	sci-electronics/electronics-menu
	gnome? ( dev-python/gnome-vfs-python )"

DEPEND="
	${CDEPEND}
	dev-util/intltool
	dev-lang/perl
	nls? ( sys-devel/gettext )"

pkg_setup() {
	python_set_active_version 2
}

src_prepare(){
	echo '#!/bin/sh' > py-compile
	epatch "${FILESDIR}"/${PV}-python.patch
	eautoreconf
}

src_configure() {
	econf \
		$(use_enable nls) \
		--disable-update-desktop-database \
		--disable-dependency-tracking
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc README ChangeLog || die
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update
	gnome2_icon_cache_update
	python_mod_optimize ${PN}
}

pkg_postrm() {
	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update
	gnome2_icon_cache_update
	python_mod_cleanup ${PN}
}
