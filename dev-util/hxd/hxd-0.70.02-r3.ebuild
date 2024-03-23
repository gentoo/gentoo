# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="Binary to hexadecimal converter"
HOMEPAGE="https://linux.xulin.de/c/"
SRC_URI="https://linux.xulin.de/c/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~mips ~ppc ~sparc ~x86"

PATCHES=(
	"${FILESDIR}"/${P}-prll-flags.patch
	"${FILESDIR}"/${P}-llong-redef.patch
)

DOCS=( README TODO )

src_prepare() {
	default
	tc-export CC
}

src_install() {
	dobin "${PN}" "un${PN}"
	doman "${PN}.1" "un${PN}.1"
	einstalldocs
}
