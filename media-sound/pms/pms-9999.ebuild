# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit autotools flag-o-matic git-r3

DESCRIPTION="Practical Music Search: an open source ncurses client for mpd, written in C++"
HOMEPAGE="https://ambientsound.github.io/pms"
EGIT_REPO_URI="https://github.com/ambientsound/pms.git"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE="regex"

RDEPEND="
	sys-libs/ncurses[unicode]
	dev-libs/glib:2
	media-libs/libmpdclient
"
DEPEND="
	virtual/pkgconfig
	${RDEPEND}
"

DOCS=( AUTHORS README TODO )

src_prepare() {
	eapply_user

	eautoreconf
}

src_configure() {
	# Required for ncurses[tinfo]
	append-cppflags $(pkg-config --cflags ncursesw)
	append-libs $(pkg-config --libs ncursesw)

	econf \
		$(use_enable regex)
}
