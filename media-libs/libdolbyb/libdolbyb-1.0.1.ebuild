# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Treat audio recordings similar to Dolby B noise reduction codecs"
HOMEPAGE="https://codeberg.org/sox_ng/libdolbyb"
SRC_URI="https://codeberg.org/sox_ng/libdolbyb/releases/download/${P}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0/3" # SHLIB in configure.ac
KEYWORDS="~amd64 ~arm ~arm64"

DEPEND="media-libs/libsndfile"
RDEPEND="${DEPEND}"

src_install() {
	default

	find "${ED}" -name '*.la' -delete || die
}
