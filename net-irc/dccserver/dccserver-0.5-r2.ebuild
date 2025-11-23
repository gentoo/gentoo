# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="Linux implementation of the mirc dccserver command"
HOMEPAGE="https://www.nih.at/dccserver/"
SRC_URI="https://www.nih.at/dccserver/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ppc ~riscv x86"

RDEPEND="dev-libs/libbsd"
DEPEND="${RDEPEND}"

PATCHES=( "${FILESDIR}/${P}-include-bsd-string-header.patch" )

src_prepare() {
	default

	# Respect AR
	sed -i -e "s/AR = /AR ?= /" lib/Makefile.in || die
}

src_compile() {
	AR="$(tc-getAR)" default
}
