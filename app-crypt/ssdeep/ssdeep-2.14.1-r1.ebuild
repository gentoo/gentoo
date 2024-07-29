# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="Computes context triggered piecewise hashes (fuzzy hashes)"
HOMEPAGE="https://ssdeep-project.github.io/ssdeep/"
SRC_URI="https://github.com/${PN}-project/${PN}/releases/download/release-${PV}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 arm arm64 ~ppc ~ppc64 ~riscv x86"

PATCHES=(
	"${FILESDIR}/${PN}-2.10-shared.patch"
)

src_prepare() {
	default
	eautoreconf
}

src_install() {
	default
	dodoc FILEFORMAT
	find "${ED}" -name '*.la' -delete || die
}
