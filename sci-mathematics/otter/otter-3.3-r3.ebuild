# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit toolchain-funcs

DESCRIPTION="An Automated Deduction System"
HOMEPAGE="http://www.cs.unm.edu/~mccune/otter/"
SRC_URI="http://www.cs.unm.edu/~mccune/otter/${P}.tar.gz"

LICENSE="otter"
SLOT="0"
KEYWORDS="amd64 ~ppc x86 ~amd64-linux ~x86-linux ~ppc-macos"
IUSE=""

RDEPEND="
	x11-libs/libX11
	x11-libs/libXaw
	x11-libs/libXt"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/${P}-build.patch
	"${FILESDIR}"/${P}-gold.patch
)

src_compile() {
	tc-export CC

	emake -C source
	emake -C mace2
}

src_install() {
	dobin bin/* source/formed/formed

	dodoc README* Legal Changelog Contents documents/*.pdf

	insinto /usr/share/${PN}
	doins -r examples examples-mace2
}
