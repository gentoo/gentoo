# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit autotools-utils

DESCRIPTION="dev-util/squashdelta delta merge tool"
HOMEPAGE="https://github.com/mgorny/squashmerge/"
SRC_URI="https://www.github.com/mgorny/${PN}/releases/download/v${PV}/${P}.tar.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="lz4 +lzo"

COMMON_DEPEND="
	lz4? ( app-arch/lz4:0= )
	lzo? ( dev-libs/lzo:2= )"
RDEPEND="${COMMON_DEPEND}
	dev-util/xdelta:3"
DEPEND=${COMMON_DEPEND}

# SquashDelta does not make much sense without a compression algo.
REQUIRED_USE="|| ( lz4 lzo )"

DOCS=( FORMAT )

src_configure() {
	local myeconfargs=(
		$(use_enable lz4)
		$(use_enable lzo)
	)

	autotools-utils_src_configure
}
