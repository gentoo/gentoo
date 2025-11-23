# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="dev-util/squashdelta delta merge tool"
HOMEPAGE="https://github.com/projg2/squashmerge/"
SRC_URI="
	https://github.com/projg2/${PN}/releases/download/v${PV}/${P}.tar.bz2
"

LICENSE="BSD"
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

DOCS=( FORMAT )

src_configure() {
	local myconf=(
		$(use_enable lz4)
		$(use_enable lzo)
	)

	econf "${myconf[@]}"
}
