# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools xdg-utils

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

PATCHES=(
	"${FILESDIR}"/${P}-slibtool.patch
)

src_prepare() {
	default

	# Remove -D.*DISABLE_DEPRECATED cflags
	find . -iname 'Makefile.am' -exec \
		sed -e '/-D[A-Z_]*DISABLE_DEPRECATED/d' -i {} + || die
	sed -e '/SUBDIRS/{s: examples::;}' -i Makefile.am || die

	eautoreconf
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
