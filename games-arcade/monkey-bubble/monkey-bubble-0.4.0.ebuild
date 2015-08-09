# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit autotools eutils gnome2

DESCRIPTION="A Puzzle Bobble clone"
HOMEPAGE="http://www.monkey-bubble.org/"
SRC_URI="http://home.gna.org/monkeybubble/downloads/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc sparc x86"
IUSE=""

RDEPEND="x11-libs/gtk+:2
	>=dev-libs/glib-2.12:2
	>=gnome-base/libglade-2.0
	>=gnome-base/libgnomeui-2.0
	>=gnome-base/librsvg-2.0
	>=gnome-base/gconf-2.0
	media-libs/gstreamer:0.10
	>=dev-libs/libxml2-2.6.7"
DEPEND="${RDEPEND}
	app-text/rarian
	app-text/gnome-doc-utils
	dev-util/intltool"

src_prepare() {
	epatch \
		"${FILESDIR}"/${P}-asneeded.patch \
		"${FILESDIR}"/${P}-gnome-doc.patch \
		"${FILESDIR}"/${P}-noesound.patch \
		"${FILESDIR}"/${P}-glib-single-include.patch
	# bug 260895
	sed -i -e 's/ -Werror//' $(find . -name Makefile.am) || die
	sed -i \
		-e '/^Icon/s/.png//' \
		-e '/^Categories/s/Application;//' \
		monkey-bubble.desktop.in || die
	AT_NOELIBTOOLIZE=yes eautoreconf
	gnome2_src_prepare
}
