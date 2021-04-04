# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="A Conway's Life simulator written in GTK+2 - fork from Gtklife"
HOMEPAGE="https://wiki.gentoo.org/wiki/No_homepage"
SRC_URI="mirror://gentoo/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-libs/atk
	dev-libs/glib
	dev-libs/gobject-introspection
	media-libs/fontconfig
	media-libs/freetype
	x11-libs/gdk-pixbuf
	x11-libs/gtk+:2
	x11-libs/libX11
	x11-libs/pango
"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-util/intltool
	sys-devel/gettext
	virtual/pkgconfig
"

PATCHES=(
	"${FILESDIR}"/${P}-gnome-vfs.patch
	"${FILESDIR}"/${P}-underlink.patch
)

src_prepare() {
	default

	eautoreconf
	intltoolize --force --copy --automake || die
}

src_install() {
	emake install \
		desktopdir=/usr/share/applications \
		pixmapdir=/usr/share/pixmaps \
		DESTDIR="${D}"

	# Let's just shift the docdir
	mv "${ED}"/usr/share/doc/${PN} "${ED}"/usr/share/doc/${PF} || die

	dodoc AUTHORS ChangeLog NEWS README TODO
}
