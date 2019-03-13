# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools git-r3

DESCRIPTION="C++ bindings for libh2o"
HOMEPAGE="https://github.com/mgorny/libh2oxx/"
SRC_URI=""
EGIT_REPO_URI="https://github.com/mgorny/libh2oxx.git"

LICENSE="BSD"
SLOT="0"
KEYWORDS=""
IUSE="debug static-libs"

RDEPEND=">=sci-libs/libh2o-0.2:0="
DEPEND="${RDEPEND}"

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	local myconf=(
		$(use_enable debug)
		$(use_enable static-libs static)
	)

	econf "${myconf[@]}"
}

src_install() {
	default
	find "${D}" -name '*.la' -delete || die
}
