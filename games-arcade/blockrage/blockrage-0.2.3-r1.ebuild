# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="Falling-blocks arcade game with a 2-player hotseat mode"
HOMEPAGE="https://blockrage.sourceforge.net/"
SRC_URI="https://downloads.sourceforge.net/${PN}/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="media-libs/libsdl[video]"
RDEPEND="${DEPEND}"

DOCS=( ChangeLog KNOWN_BUGS README TODO )

PATCHES=(
	# Removing error due to wrong detection of cross-compile mode
	"${FILESDIR}"/${P}-config.patch
	"${FILESDIR}"/${P}-statx.patch
)

src_configure() {
	tc-export CC
	default
}
