# Copyright 2022-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="Intel C for Media RunTime GPU kernel manager"
HOMEPAGE="https://github.com/intel/cmrt"
SRC_URI="https://github.com/intel/cmrt/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~x86 ~amd64-linux ~x86-linux"

BDEPEND="virtual/pkgconfig"
DEPEND="
	>=x11-libs/libdrm-2.4.23[video_cards_intel]
	>=media-libs/libva-2.0.0
"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}/${P}-musl-fix.patch"
)

src_prepare() {
	default
	eautoreconf
}

src_install() {
	default
	find "${ED}" -type f -name '*.la' -delete || die
}
