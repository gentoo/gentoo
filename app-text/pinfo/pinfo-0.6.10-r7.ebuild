# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit autotools flag-o-matic

DESCRIPTION="Hypertext info and man viewer based on (n)curses"
HOMEPAGE="http://pinfo.alioth.debian.org/"
SRC_URI="https://alioth.debian.org/frs/download.php/3351/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86"
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
	"${FILESDIR}"/${PN}-0.6.9-as-needed.patch
	"${FILESDIR}"/${PN}-0.6.9-GROFF_NO_SGR.patch
	"${FILESDIR}"/${PN}-0.6.9-lzma-xz.patch
	"${FILESDIR}"/${PN}-0.6.10-version.patch
	"${FILESDIR}"/${PN}-0.6.10-info-suffix.patch
	"${FILESDIR}"/${PN}-0.6.10-dir-file.patch
	"${FILESDIR}"/${PN}-0.6.10-tinfo.patch
	"${FILESDIR}"/${PN}-0.6.10-gettext-0.19.patch
	"${FILESDIR}"/${PN}-0.6.10-ncurses-check.patch
	"${FILESDIR}"/${PN}-0.6.10-libc-basename.patch
	"${FILESDIR}"/${PN}-0.6.10-clearfilenameprefix.patch
	"${FILESDIR}"/${PN}-0.6.10-gcc-7-inline.patch
)

src_prepare() {
	default

	eautoreconf

	append-cflags -D_BSD_SOURCE -D_DEFAULT_SOURCE # sbrk()
}

src_configure() {
	econf \
		$(use_with readline) \
		$(use_enable nls)
}

src_install() {
	emake DESTDIR="${D}" sysconfdir="${EPREFIX}/etc" install
}
