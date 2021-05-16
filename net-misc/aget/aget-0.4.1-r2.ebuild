# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="multithreaded HTTP download accelerator"
HOMEPAGE="http://www.enderunix.org/aget/"
SRC_URI="http://www.enderunix.org/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~arm ~mips ~ppc ppc64 ~sparc x86 ~amd64-linux ~x86-linux"

PATCHES=(
	"${FILESDIR}"/${P}-overflow.patch
	"${FILESDIR}"/${P}-fno-common.patch
)

src_compile() {
	emake CC="$(tc-getCC)"
}
