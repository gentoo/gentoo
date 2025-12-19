# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools dot-a

DESCRIPTION="barcode generator"
HOMEPAGE="https://www.gnu.org/software/barcode/"
SRC_URI="mirror://gnu/barcode/${P}.tar.xz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~ppc ~ppc64 x86"

RDEPEND="app-text/libpaper"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/${P}-fno-common.patch
	"${FILESDIR}"/${P}-properly-install-static-lib.patch
	"${FILESDIR}"/${P}-not-a-literal-string.patch
)

src_prepare() {
	default

	eautoreconf
	lto-guarantee-fat
}

src_install() {
	default
	strip-lto-bytecode
}
