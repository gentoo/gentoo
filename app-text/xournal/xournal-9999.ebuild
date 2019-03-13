# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

[[ ${PV} == *9999 ]] && GNOME2_EAUTORECONF=yes

inherit gnome2

if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://git.code.sf.net/p/xournal/code"
	unset SRC_URI
else
	KEYWORDS="~amd64 ~x86"
	SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"
fi

DESCRIPTION="An application for notetaking, sketching, and keeping a journal using a stylus"
HOMEPAGE="http://xournal.sourceforge.net/"

LICENSE="GPL-2"
SLOT="0"
IUSE="+pdf"

COMMONDEPEND="
	app-text/poppler[cairo]
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
	default
	emake DESTDIR="${D}" desktop-install

	dodoc -r html-doc/*
}
