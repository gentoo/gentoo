# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="converts RAW format (.bin/.cue) files to ISO/WAV format"
HOMEPAGE="http://users.andara.com/~doiron/bin2iso/"
SRC_URI="mirror://gentoo/${P}.tar.bz2"
S="${WORKDIR}/${PN}"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~alpha amd64 ppc sparc x86 ~amd64-linux ~x86-linux ~ppc-macos"

PATCHES=(
	"${FILESDIR}"/${P}-sanity-checks.patch
	"${FILESDIR}"/${P}-fixes.patch
)

src_compile() {
	tc-export CC
	emake bin2iso19b_linux
}

src_install() {
	newbin bin2iso19b_linux bin2iso
	dodoc readme.txt
}
