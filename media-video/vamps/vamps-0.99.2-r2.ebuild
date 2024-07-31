# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="Very fast requantisizing tool for backup DVDs"
HOMEPAGE="http://vamps.sourceforge.net/"
SRC_URI="https://downloads.sourceforge.net/vamps/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"

DEPEND=">=media-libs/libdvdread-0.9.4"
RDEPEND="${DEPEND}
	>=media-video/dvdauthor-0.6.10"

PATCHES=(
	"${FILESDIR}/${P}-premature-eof.patch"
	"${FILESDIR}/${P}-musl.patch"
)

src_compile() {
	emake CC="$(tc-getCC)" CFLAGS="${CFLAGS}" LDFLAGS="${LDFLAGS}"
}

src_install() {
	dobin vamps/vamps play_cell/play_cell
}
