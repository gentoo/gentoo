# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit toolchain-funcs

DESCRIPTION="Speech synthesizer based on the concatenation of diphones"
HOMEPAGE="https://github.com/numediart/MBROLA"
SRC_URI="https://github.com/numediart/MBROLA/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="AGPL-3+"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~loong ppc ppc64 ~riscv sparc x86"

RDEPEND="app-accessibility/mbrola-voices"

S="${WORKDIR}/MBROLA-${PV}"

PATCHES=(
	"${FILESDIR}"/${P}-Makefile.patch
)

src_compile() {
	emake -j1 CC="$(tc-getCC)"
}

src_install() {
	dobin Bin/mbrola
	DOCS=( README.md Documentation/*.txt )
	einstalldocs
}
