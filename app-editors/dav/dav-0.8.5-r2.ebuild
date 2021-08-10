# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="A minimal console text editor"
HOMEPAGE="http://dav-text.sourceforge.net/"
# The maintainer does not keep sourceforge's mirrors up-to-date,
# so we point to the website's store of files.
SRC_URI="http://dav-text.sourceforge.net/files/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ppc x86 ~amd64-linux ~x86-linux ~ppc-macos"

BDEPEND="virtual/pkgconfig"
RDEPEND="sys-libs/ncurses:0="
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}/${P}-asneeded.patch"
	"${FILESDIR}/${P}-davrc-buffer-overflow.patch"
	"${FILESDIR}/fix-Wformat-security-warnings.patch"
	"${FILESDIR}/${PN}-0.8.5-fno-common.patch"
	"${FILESDIR}/${PN}-0.8.5-makefile.patch"
)

DOCS=( README )

# Makefile only
src_configure() { :; }

src_compile() {
	emake \
		CC="$(tc-getCC)" \
		CFLAGS="${CFLAGS}" \
		LDFLAGS="${LDFLAGS} $( $(tc-getPKG_CONFIG) --libs ncurses)"
}

src_install() {
	default
	docompress -x /usr/share/man/man1/dav.1.gz
}
