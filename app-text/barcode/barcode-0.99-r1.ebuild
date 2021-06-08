# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="barcode generator"
HOMEPAGE="https://www.gnu.org/software/barcode/"
SRC_URI="mirror://gnu/barcode/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm ~ppc ~ppc64 x86 ~amd64-linux ~x86-linux ~ppc-macos"

RDEPEND="app-text/libpaper"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/${P}-fno-common.patch
	"${FILESDIR}"/${P}-install-static-lib.patch
)

src_prepare() {
	sed -i -e '/^LDFLAGS =/s:=:+=:' \
		-e "/^aLIBDIR/s:lib:$(get_libdir):" \
		-e '/^INFODIR/s:info:share/info:' \
		-e '/^MAN/s:man:share/man:' \
		Makefile.in || die

	default
}

src_configure() {
	econf --disable-shared
}
