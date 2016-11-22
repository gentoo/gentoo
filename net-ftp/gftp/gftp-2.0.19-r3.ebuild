# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit gnome2

DESCRIPTION="Gnome based FTP Client"
SRC_URI="http://www.gftp.org/${P}.tar.bz2"
HOMEPAGE="http://www.gftp.org"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ~ppc ~ppc64 ~sparc x86 ~x86-fbsd"
IUSE="gtk libressl ssl"

RDEPEND="
	dev-libs/glib:2
	sys-devel/gettext
	sys-libs/ncurses:0=
	sys-libs/readline:0
	gtk? ( x11-libs/gtk+:2 )
	ssl? (
		!libressl? ( dev-libs/openssl:0= )
		libressl? ( dev-libs/libressl:0= ) )
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
"

PATCHES=(
	# Fix SIGSEGV for gftp_expand_path function
	"${FILESDIR}/${P}-${PN}-expand-path-sigsegv.patch"

	# https://bugzilla.gnome.org/show_bug.cgi?id=740785
	"${FILESDIR}/${P}-desktop.patch"
)

src_configure() {
	gnome2_src_configure \
		$(use_enable gtk gtkport) \
		$(use_enable ssl)
}

src_install() {
	gnome2_src_install
	dodoc docs/USERS-GUIDE
}
