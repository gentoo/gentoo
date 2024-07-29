# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="A modified version of mv, used to convert filenames to lower/upper case"
HOMEPAGE="https://www.ibiblio.org/pub/Linux/utils/file"
SRC_URI="https://www.ibiblio.org/pub/Linux/utils/file/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"

DEPEND="dev-libs/shhopt"
RDEPEND="${DEPEND}"
BDEPEND="sys-apps/groff"

PATCHES=(
	"${FILESDIR}"/${P}-includes.patch
	"${FILESDIR}"/${P}-flags.patch
)

src_configure() {
	tc-export CC
}

src_install() {
	dobin mvcase
	doman mvcase.1
}
