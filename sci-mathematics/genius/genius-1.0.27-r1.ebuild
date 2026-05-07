# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
GNOME2_LA_PUNT="yes"
GNOME2_EAUTORECONF="yes"

inherit gnome2

DESCRIPTION="Genius Mathematics Tool and the GEL Language"
HOMEPAGE="https://www.jirka.org/genius.html"
SRC_URI="${SRC_URI}
	doc? ( https://www.jirka.org/${PN}-reference.pdf )"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="amd64 ~arm64 ~x86"
IUSE="doc +gui"

RDEPEND="
	>=dev-libs/glib-2.41.1:2
	dev-libs/gmp:0=
	dev-libs/mpfr:0=
	sys-libs/ncurses:0=
	sys-libs/readline:0=
	gui? (
		x11-libs/cairo
		x11-libs/gdk-pixbuf:2
		>=x11-libs/gtk+-3.21.4:3
		x11-libs/gtksourceview:4
		x11-libs/pango
		>=x11-libs/vte-0.50.0:2.91
	)
"
DEPEND="${RDEPEND}
	dev-util/gtk-update-icon-cache
	dev-util/intltool
	dev-build/autoconf-archive
	app-alternatives/lex
	app-alternatives/yacc
" # eautoreconf needs dev-build/autoconf-archive
# dev-util/gtk-update-icon-cache because configure checks for it for some reason and never calls it with DESTDIR set..

PATCHES=(
	# Unrecognized --disable-scrollkeeper warning comes from gnome2.eclass adding it based on grep, but upstream has them commented out in .ac with "#" instead of "dnl"
	"${FILESDIR}/${PN}-1.0.24-no_scrollkeeper.patch"
	"${FILESDIR}/${P}-disableGnomeIf.patch"
)

src_configure() {
	gnome2_src_configure \
		$(use_enable gui gnome) \
		--enable-nls \
		--disable-extra-gcc-optimization \
		--disable-static
}

src_install() {
	use doc && DOCS+=" ${DISTDIR}/${PN}-reference.pdf"
	gnome2_src_install
}
