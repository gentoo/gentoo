# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-embedded/gnome-avrdude/gnome-avrdude-0.1.ebuild,v 1.6 2014/05/14 17:09:30 tomwij Exp $

EAPI=5

inherit gnome2 autotools

DESCRIPTION="GNOME GUI for avrdude"
HOMEPAGE="http://www.sourceforge.net/projects/gnome-avrdude/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=dev-libs/glib-2
	x11-libs/gtk+:2
	gnome-base/gconf
	gnome-base/libgnome
	gnome-base/libgnomeui
	gnome-base/libglade
	x11-libs/pango"

DEPEND="${RDEPEND}
	virtual/pkgconfig"

RDEPEND="${RDEPEND}
	dev-embedded/avrdude"

DOCS="AUTHORS NEWS README"

src_prepare() {
	sed -i \
		-e :a -e '/\\$/N; s/\\\n//; ta' \
		-e 's/^gnome_avrdude/#gnome_avrdude/' \
		"${S}"/Makefile.am \
		|| die "sed failed"
	sed -i \
		-e 's/Wall\\/Wall/' \
		-e 's/^[\t ]*-g//' \
		"${S}"/src/Makefile.am \
		|| die "sed failed"

	# Remove Application category from .desktop file.
	sed -i 's/;Application;/;/' gnome-avrdude.desktop

	eautoreconf
}
