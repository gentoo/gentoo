# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="Search files for a byte sequence specified on the command line"
HOMEPAGE="https://www.lith.at/binfind/"
SRC_URI="https://www.lith.at/binfind/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~riscv ~x86"

PATCHES=(
	"${FILESDIR}"/${P}-clang16.patch
)

src_prepare() {
	default

	eautoreconf #870832
}
