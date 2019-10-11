# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit eutils

DESCRIPTION="Convert ordinary English text into text that mimics a stereotyped dialect"
HOMEPAGE="http://www.hyperrealm.com/talkfilters/talkfilters.html"
SRC_URI="http://www.hyperrealm.com/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 hppa ~mips ppc x86 ~amd64-linux ~x86-linux ~ppc-macos"
IUSE=""

PATCHES=(
	"${FILESDIR}"/${P}-format-security.patch
	)

src_prepare() {
	epatch "${PATCHES[@]}"
}
