# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="mp3 and ogg streamer (include mp3cue and mp3cut)"
HOMEPAGE="http://www.bl0rg.net/software/poc"
SRC_URI="http://www.bl0rg.net/software/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"

BDEPEND="
	sys-devel/bison
	sys-devel/flex"

PATCHES=(
	"${FILESDIR}"/${P}-fec-pkt-prototype.patch
	"${FILESDIR}"/${P}-file-perms.patch
	"${FILESDIR}"/${P}-fix-build-system.patch
)

src_configure() {
	tc-export CC
}
