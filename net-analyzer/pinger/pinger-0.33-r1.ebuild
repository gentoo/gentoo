# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools flag-o-matic

DESCRIPTION="Cyclic multi ping utility for selected adresses using GTK/ncurses"
HOMEPAGE="http://aa.vslib.cz/silk/projekty/pinger/"
SRC_URI="http://aa.vslib.cz/silk/projekty/pinger/download/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE="gtk2 gtk3 ncurses nls"

REQUIRED_USE="|| ( gtk2 gtk3 ncurses )
	?? ( gtk2 gtk3 )"

GTK_DEPEND="dev-libs/glib:2"
RDEPEND="gtk2? (
		${GTK_DEPEND}
		>=x11-libs/gtk+-2.4:2
	)
	gtk3? (
		${GTK_DEPEND}
		>=x11-libs/gtk+-3.12:3
	)
	ncurses? ( sys-libs/ncurses:= )"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

DOCS=( AUTHORS BUGS ChangeLog NEWS README )

PATCHES=(
	"${FILESDIR}"/${P}-gentoo.patch
	"${FILESDIR}"/${P}-musl-int-types.patch
	"${FILESDIR}"/${P}-clang16.patch
)

src_prepare() {
	default

	sed -i -e '/Root privileges/d' src/Makefile.am || die

	eautoreconf
}

src_configure() {
	append-cppflags -D_GNU_SOURCE

	econf \
		$(usex gtk2 --enable-gtk=gtk2 '') \
		$(usex gtk3 --enable-gtk=gtk3 '') \
		$(use_enable ncurses) \
		$(use_enable nls)
}
