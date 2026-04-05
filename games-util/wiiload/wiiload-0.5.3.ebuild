# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="Load homebrew apps over the network to your Wii"
HOMEPAGE="http://wiibrew.org/wiki/Wiiload https://github.com/devkitPro/wiiload"
SRC_URI="https://github.com/devkitPro/wiiload/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="virtual/zlib:="
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}/${P}-stdbool.patch"
)

src_prepare() {
	default
	eautoreconf
}
