# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit autotools flag-o-matic git-r3

DESCRIPTION="Hypertext info and man viewer based on (n)curses"
HOMEPAGE="https://github.com/baszoetekouw/pinfo"
EGIT_REPO_URI="https://github.com/baszoetekouw/pinfo.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="nls readline"

RDEPEND="
	sys-libs/ncurses:0=
	sys-libs/readline:0=
	nls? ( virtual/libintl )
"

DEPEND="
	${RDEPEND}
	sys-apps/texinfo
	sys-devel/bison
	virtual/pkgconfig
	nls? ( sys-devel/gettext )
"
PATCHES=(
	"${FILESDIR}"/${PN}-0.6.9-GROFF_NO_SGR.patch
	"${FILESDIR}"/${PN}-0.6.9-lzma-xz.patch
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	append-cflags -D_BSD_SOURCE -D_DEFAULT_SOURCE # sbrk()

	econf \
		$(use_with readline) \
		$(use_enable nls)
}

src_install() {
	emake DESTDIR="${D}" sysconfdir="${EPREFIX}/etc" install
}
