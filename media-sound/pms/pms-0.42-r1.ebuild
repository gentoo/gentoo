# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/pms/pms-0.42-r1.ebuild,v 1.1 2014/01/23 11:46:20 pinkbyte Exp $

EAPI=5

inherit eutils autotools

DESCRIPTION="Practical Music Search: an open source ncurses client for mpd, written in C++"
HOMEPAGE="http://pms.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="regex"

RDEPEND="
	sys-libs/ncurses
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

	epatch_user

	eautoreconf
}

src_configure() {
	econf \
		$(use_enable regex)
}
