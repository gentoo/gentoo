# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit xdg-utils

DESCRIPTION="Gtk+ Widgets for live display of large amounts of fluctuating numerical data"
HOMEPAGE="https://sourceforge.net/projects/gtkdatabox/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="examples +glade"

RDEPEND="
	dev-libs/atk
	dev-libs/glib:2
	media-libs/harfbuzz:=
	x11-libs/cairo
	x11-libs/gtk+:3
	x11-libs/gdk-pixbuf:2
	x11-libs/pango
	glade? ( dev-util/glade:3.10= )
"
DEPEND="${RDEPEND}"

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
		$(use_enable glade) \
		--enable-libtool-lock
}

src_install() {
	default

	find "${ED}" -type f -name '*.la' -delete || die

	dodoc AUTHORS ChangeLog README TODO

	if use examples; then
		docinto examples
		dodoc "${S}"/examples/*
	fi
}

maybe_update_xdg_icon_cache() {
	if use glade; then
		xdg_icon_cache_update
	fi
}

pkg_postinst() {
	maybe_update_xdg_icon_cache
}

pkg_postrm() {
	maybe_update_xdg_icon_cache
}
