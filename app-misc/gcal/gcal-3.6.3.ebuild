# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit eutils flag-o-matic toolchain-funcs

DESCRIPTION="The GNU Calendar - a replacement for cal"
HOMEPAGE="https://www.gnu.org/software/gcal/"
SRC_URI="mirror://gnu/gcal/${P}.tar.xz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="amd64 ~arm ppc x86 ~amd64-linux ~x86-linux ~ppc-macos"
IUSE="ncurses nls unicode"

DEPEND="
	app-arch/xz-utils
	nls? ( >=sys-devel/gettext-0.17 )"
RDEPEND="nls? ( virtual/libintl )"

DOCS=( BUGS LIMITATIONS NEWS README THANKS TODO )

src_configure() {
	tc-export CC
	append-cppflags -D_GNU_SOURCE
	econf \
		--disable-rpath \
		$(use_enable nls) \
		$(use_enable ncurses term) \
		$(use_enable unicode)
}
