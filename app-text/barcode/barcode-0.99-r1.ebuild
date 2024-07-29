# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="barcode generator"
HOMEPAGE="https://www.gnu.org/software/barcode/"
SRC_URI="mirror://gnu/barcode/${P}.tar.xz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~ppc ~ppc64 x86 ~amd64-linux ~x86-linux ~ppc-macos"

RDEPEND="app-text/libpaper"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/${P}-fno-common.patch
	"${FILESDIR}"/${P}-install-static-lib.patch
	"${FILESDIR}"/${P}-not-a-literal-string.patch
)

src_prepare() {
	default

	sed -i -e '/^LDFLAGS =/s:=:+=:' \
		-e "/^aLIBDIR/s:lib:$(get_libdir):" \
		-e '/^INFODIR/s:info:share/info:' \
		-e '/^MAN/s:man:share/man:' \
		Makefile.in || die

	eautoreconf
}

src_configure() {
	econf --disable-shared
}
