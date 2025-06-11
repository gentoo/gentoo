# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Efficient (partially uncompressed) SquashFS binary delta tool"
HOMEPAGE="https://github.com/projg2/squashdelta/"
SRC_URI="
	https://github.com/projg2/squashdelta/releases/download/v${PV}/${P}.tar.bz2
"

# uses public-domain murmurhash3
LICENSE="BSD public-domain"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="lz4 +lzo"
# SquashDelta does not make much sense without a compression algo.
REQUIRED_USE="|| ( lz4 lzo )"

DEPEND="
	lz4? ( app-arch/lz4:0= )
	lzo? ( dev-libs/lzo:2= )
"
RDEPEND="
	${DEPEND}
	dev-util/xdelta:3
"

src_configure() {
	local myconf=(
		$(use_enable lz4)
		$(use_enable lzo)
	)

	econf "${myconf[@]}"
}
