# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils

DESCRIPTION="Gtk+ Widgets for live display of large amounts of fluctuating numerical data"
HOMEPAGE="https://sourceforge.net/projects/gtkdatabox/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="examples +glade static-libs test"
RESTRICT="!test? ( test )"

RDEPEND="x11-libs/cairo
	x11-libs/gtk+:2
	x11-libs/pango
	glade? ( gnome-base/libglade )"
DEPEND=${RDEPEND}

src_prepare() {
	default

	# Remove -D.*DISABLE_DEPRECATED cflags
	find . -iname 'Makefile.am' -exec \
		sed -e '/-D[A-Z_]*DISABLE_DEPRECATED/d' -i {} + || die
	# Do Makefile.in after Makefile.am to avoid automake maintainer-mode
	find . -iname 'Makefile.in' -exec \
		sed -e '/-D[A-Z_]*DISABLE_DEPRECATED/d' -i {} + || die
	sed -e '/SUBDIRS/{s: examples::;}' -i Makefile.am -i Makefile.in || die
}

src_configure() {
	econf \
		$(use_enable glade libglade) \
		--disable-glade \
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
