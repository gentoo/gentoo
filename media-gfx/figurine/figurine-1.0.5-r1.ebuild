# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="A vector based graphics editor similar to xfig, but simpler"
HOMEPAGE="http://figurine.sourceforge.net/"
SRC_URI="mirror://sourceforge/figurine/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86 ~amd64-linux ~x86-linux ~ppc-macos"

DEPEND="media-gfx/transfig"
RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}"/${P}-fno-common.patch )

src_configure() {
	tc-export CC
	econf
}
