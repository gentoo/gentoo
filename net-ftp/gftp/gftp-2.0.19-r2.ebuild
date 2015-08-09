# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils

DESCRIPTION="Gnome based FTP Client"
SRC_URI="http://www.gftp.org/${P}.tar.bz2"
HOMEPAGE="http://www.gftp.org"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ppc ppc64 sparc x86 ~x86-fbsd"
IUSE="gtk ssl"

RDEPEND="dev-libs/glib:2
		 sys-devel/gettext
		 sys-libs/ncurses
		 sys-libs/readline:0
		 gtk? ( x11-libs/gtk+:2 )
		 ssl? ( dev-libs/openssl:0 )"
DEPEND="${RDEPEND}
		virtual/pkgconfig"

src_prepare() {
	# Fix SIGSEGV for gftp_expand_path function
	epatch "${FILESDIR}/${P}-${PN}-expand-path-sigsegv.patch"
}

src_configure() {
	econf $(use_enable gtk gtkport) $(use_enable ssl)
}

src_install() {
	emake DESTDIR="${D}" install
	dodoc ChangeLog* README* THANKS TODO docs/USERS-GUIDE
}
