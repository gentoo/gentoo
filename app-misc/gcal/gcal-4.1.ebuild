# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit flag-o-matic toolchain-funcs

DESCRIPTION="The GNU Calendar - a replacement for cal"
HOMEPAGE="https://www.gnu.org/software/gcal/"
SRC_URI="mirror://gnu/gcal/${P}.tar.xz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos"
IUSE="ncurses nls unicode"

DEPEND="
	app-arch/xz-utils
	nls? ( >=sys-devel/gettext-0.17 )
	unicode? ( dev-libs/libunistring:= )"

RDEPEND="nls? ( virtual/libintl )
	unicode? ( dev-libs/libunistring:= )"

DOCS=( BUGS LIMITATIONS NEWS README THANKS TODO )

src_configure() {
	tc-export CC
	append-cppflags -D_GNU_SOURCE
	use unicode && append-libs -lunistring
	econf \
		--disable-rpath \
		$(use_enable nls) \
		$(use_enable ncurses term) \
		$(use_enable unicode)
}
