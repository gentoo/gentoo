# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit autotools eutils flag-o-matic toolchain-funcs

DESCRIPTION="Practical Music Search: an open source ncurses client for mpd, written in C++"
HOMEPAGE="https://ambientsound.github.io/pms/"
SRC_URI="https://github.com/ambientsound/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="regex"

RDEPEND="
	sys-libs/ncurses:0=
	dev-libs/glib:2
	virtual/libintl
	regex? ( dev-libs/boost:= )
"
DEPEND="
	virtual/pkgconfig
	sys-devel/gettext
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
	append-cflags $($(tc-getPKG_CONFIG) --cflags ncursesw)
	append-libs $($(tc-getPKG_CONFIG) --libs ncursesw)

	econf \
		$(use_enable regex)
}
