# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit eutils autotools flag-o-matic

DESCRIPTION="Practical Music Search: an open source ncurses client for mpd, written in C++"
HOMEPAGE="https://ambientsound.github.io/pms/"
SRC_URI="https://github.com/ambientsound/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="regex"

RDEPEND="
	sys-libs/ncurses:=
	dev-libs/glib:2
	regex? ( dev-libs/boost:= )
"
DEPEND="
	virtual/pkgconfig
	${RDEPEND}
"

DOCS=( AUTHORS README TODO )

src_prepare() {
	# bug #424717
	sed -i -e "s:^CXXFLAGS +=:AM_CXXFLAGS =:g" Makefile.am || die 'sed on Makefile.am failed'

	# Compatibility with automake 1.14
	sed -i -e '/AM_INIT_AUTOMAKE/s/-Werror/subdir-objects/' configure.ac || die 'sed on configure.ac failed'

	# bug #351995
	sed -i -e '394s/BUFFER/ERRORSTR/' src/libmpdclient.c || die 'sed on libmpdclient.c failed'

	eapply_user

	eautoreconf
}

src_configure() {
	# fixes build with ncurses[tinfo], bug #526530
	append-cflags $(pkg-config --cflags ncursesw)
	append-libs $(pkg-config --libs ncursesw)

	econf \
		$(use_enable regex)
}
