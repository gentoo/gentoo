# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

GCONF_DEBUG=no

inherit gnome2

DESCRIPTION="Xournal is an application for notetaking, sketching, and keeping a journal using a stylus"
HOMEPAGE="http://xournal.sourceforge.net/"

LICENSE="GPL-2"

SLOT="0"
IUSE="+pdf"

if [[ "${PV}" != "9999" ]]; then
	SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
else
	inherit git-2 autotools
	SRC_URI=""
	KEYWORDS=""
	EGIT_REPO_URI="git://git.code.sf.net/p/xournal/code"
	EGIT_PROJECT="${PN}"
	EGIT_BOOTSTRAP="autogen.sh"
fi

COMMONDEPEND="
	app-text/poppler:=[cairo]
	dev-libs/atk
	dev-libs/glib
	gnome-base/libgnomecanvas
	media-libs/freetype
	media-libs/fontconfig
	sys-libs/zlib
	x11-libs/cairo
	x11-libs/gdk-pixbuf
	x11-libs/gtk+:2
	x11-libs/pango
"
RDEPEND="${COMMONDEPEND}
	pdf? ( app-text/poppler[utils] app-text/ghostscript-gpl )
"
DEPEND="${COMMONDEPEND}
	virtual/pkgconfig
"

src_install() {
	emake DESTDIR="${D}" install
	emake DESTDIR="${D}" desktop-install

	dodoc ChangeLog AUTHORS README
	dohtml -r html-doc/*
}
