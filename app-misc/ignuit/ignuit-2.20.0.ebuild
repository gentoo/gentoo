# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

DESCRIPTION="Memorization aid based on the Leitner flashcard system"
HOMEPAGE="http://homepages.ihug.co.nz/~trmusson/programs.html#ignuit"
SRC_URI="http://homepages.ihug.co.nz/~trmusson/stuff/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 x86"
IUSE="examples"

RDEPEND="app-text/dvipng
	>=app-text/gnome-doc-utils-0.3.2
	app-text/scrollkeeper
	dev-libs/glib:2
	dev-libs/libxml2:2
	dev-libs/libxslt
	>=gnome-base/libgnomeui-2.22.1
	gnome-base/gconf:2
	gnome-base/libglade:2.0
	>=media-libs/gstreamer-0.10.20:0.10
	x11-libs/gtk+:2
	x11-libs/pango
	virtual/latex-base"

DEPEND="${RDEPEND}
	dev-util/intltool
	sys-devel/gettext"

src_install() {
	emake DESTDIR="${D}" install
	dodoc AUTHORS NEWS README TODO

	if use examples; then
		insinto /usr/share/doc/${PF}
		doins -r examples
	fi
}
