# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="bookmarksync synchronizes various browser bookmark files"
HOMEPAGE="https://sourceforge.net/projects/booksync/"
SRC_URI="mirror://sourceforge/booksync/${P}.tar.gz"

LICENSE="GPL-2"
KEYWORDS="~amd64 ppc x86"
SLOT="0"

IUSE="perl"
RESTRICT="mirror"

DEPEND=""
RDEPEND="${DEPEND}
	perl? ( dev-lang/perl )"

src_prepare() {
	default
	sed -i Makefile \
		-e 's|g++|$(CXX) $(CFLAGS)|g' \
		-e 's| -o | $(LDFLAGS)&|g' \
		|| die "sed Makefile"
	tc-export CXX
}

src_install() {
	dobin bookmarksync
	if use perl ; then
		dobin tools/bookmarksync.pl
		dodoc tools/README.tools
	fi
	dodoc README TODO DEVELOPERS
}

pkg_postinst() {
	use perl && ewarn "You will need to modify bookmarksync.pl before use"
}
