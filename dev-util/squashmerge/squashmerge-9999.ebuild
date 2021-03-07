# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

EGIT_REPO_URI="https://github.com/mgorny/${PN}.git"
inherit autotools git-r3

DESCRIPTION="dev-util/squashdelta delta merge tool"
HOMEPAGE="https://github.com/mgorny/squashmerge/"
SRC_URI=""

LICENSE="BSD"
SLOT="0"
KEYWORDS=""
IUSE="lz4 +lzo"
# SquashDelta does not make much sense without a compression algo.
REQUIRED_USE="|| ( lz4 lzo )"

COMMON_DEPEND="
	lz4? ( app-arch/lz4:0= )
	lzo? ( dev-libs/lzo:2= )"
RDEPEND="${COMMON_DEPEND}
	dev-util/xdelta:3"
DEPEND=${COMMON_DEPEND}

DOCS=( FORMAT )

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	local myconf=(
		$(use_enable lz4)
		$(use_enable lzo)
	)

	econf "${myconf[@]}"
}
