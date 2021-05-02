# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit gnome2

DESCRIPTION="Gnome based FTP Client"
SRC_URI="http://www.gftp.org/${P}.tar.bz2"
HOMEPAGE="http://www.gftp.org"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ppc ppc64 sparc x86"
IUSE="gtk ssl"

RDEPEND="
	dev-libs/glib:2
	sys-devel/gettext
	sys-libs/ncurses:0=
	sys-libs/readline:0
	gtk? ( x11-libs/gtk+:2 )
	ssl? (
		dev-libs/openssl:0=
	)
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
"

PATCHES=(
	# Fix SIGSEGV for gftp_expand_path function
	"${FILESDIR}/${P}-${PN}-expand-path-sigsegv.patch"

	# https://bugzilla.gnome.org/show_bug.cgi?id=740785
	"${FILESDIR}/${P}-desktop.patch"

	# https://bugs.gentoo.org/692230
	"${FILESDIR}"/${P}-glibc-2.30.patch
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
