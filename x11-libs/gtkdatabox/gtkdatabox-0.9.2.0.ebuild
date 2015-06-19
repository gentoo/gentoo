# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-libs/gtkdatabox/gtkdatabox-0.9.2.0.ebuild,v 1.4 2015/06/09 13:33:34 xmw Exp $

EAPI="4"
inherit eutils

DESCRIPTION="Gtk+ Widgets for live display of large amounts of fluctuating numerical data"
HOMEPAGE="http://sourceforge.net/projects/gtkdatabox/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="doc examples +glade static-libs test"

RDEPEND="
	glade? (
		gnome-base/libglade
	)
	x11-libs/cairo
	x11-libs/gtk+:2
	x11-libs/pango
"
DEPEND=${RDEPEND}

src_prepare() {
	# Remove -D.*DISABLE_DEPRECATED cflags
	find . -iname 'Makefile.am' -exec \
		sed -e '/-D[A-Z_]*DISABLE_DEPRECATED/d' -i {} + || die "sed 1 failed"
	# Do Makefile.in after Makefile.am to avoid automake maintainer-mode
	find . -iname 'Makefile.in' -exec \
		sed -e '/-D[A-Z_]*DISABLE_DEPRECATED/d' -i {} + || die "sed 2 failed"
	sed -e '/SUBDIRS/{s: examples::;}' -i Makefile.am -i Makefile.in || die
}

src_configure() {
	econf \
		$(use_enable doc gtk-doc) \
		$(use_enable glade libglade) \
		$(use_enable glade) \
		$(use_enable static-libs static) \
		$(use_enable test gtktest) \
		--disable-dependency-tracking \
		--enable-libtool-lock
}

src_install() {
	default

	prune_libtool_files

	dodoc AUTHORS ChangeLog README TODO
	if use examples; then
		docinto examples
		dodoc "${S}"/examples/*
	fi
}
