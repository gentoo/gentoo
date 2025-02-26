# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="Convert ordinary English text into text that mimics a stereotyped dialect"
HOMEPAGE="https://www.hyperrealm.com/talkfilters/talkfilters.html"
SRC_URI="https://www.hyperrealm.com/talkfilters/packages/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~hppa ~mips ~ppc ~x86 ~amd64-linux ~x86-linux ~ppc-macos"

PATCHES=(
	"${FILESDIR}"/${P}-format-security.patch
	"${FILESDIR}"/${P}-string.patch
)

src_install() {
	default
	find "${ED}" -name '*.la' -delete || die
}
