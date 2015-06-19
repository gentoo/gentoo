# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-libs/goocanvas/goocanvas-1.0.0.ebuild,v 1.13 2014/11/23 22:12:48 pacho Exp $

EAPI="5"
GCONF_DEBUG=no
GNOME2_LA_PUNT=yes
GNOME_TARBALL_SUFFIX="bz2"

inherit eutils gnome2 libtool

DESCRIPTION="Canvas widget for GTK+ using the cairo 2D library for drawing"
HOMEPAGE="https://wiki.gnome.org/Projects/GooCanvas"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="alpha amd64 ia64 ppc ppc64 sparc x86 ~x86-fbsd ~amd64-linux ~x86-linux"
IUSE="examples"

RDEPEND="
	>=x11-libs/gtk+-2.12:2
	>=dev-libs/glib-2.10:2
	>=x11-libs/cairo-1.4
"
DEPEND="${RDEPEND}
	dev-util/gtk-doc-am
	virtual/pkgconfig
"

src_prepare() {
	# https://bugzilla.gnome.org/show_bug.cgi?id=671766
	epatch "${FILESDIR}"/${P}-gold.patch

	# Fails to build with recent GTK+
	sed -e "s/-D.*_DISABLE_DEPRECATED//g" \
		-i src/Makefile.am src/Makefile.in demo/Makefile.am demo/Makefile.in \
		|| die "sed 1 failed"

	sed -e 's/^\(SUBDIRS =.*\)demo\(.*\)$/\1\2/' \
		-i Makefile.am Makefile.in || die "sed 2 failed"

	gnome2_src_prepare
}

src_configure() {
	gnome2_src_configure \
		--disable-rebuilds \
		--disable-static
}

src_install() {
	gnome2_src_install

	if use examples; then
		insinto /usr/share/doc/${P}/examples/
		doins demo/*.c demo/flower.png demo/toroid.png
	fi
}
