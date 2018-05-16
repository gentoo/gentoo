# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

AUTOTOOLS_AUTORECONF=yes

inherit autotools-utils git-r3

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

src_configure() {
	local myeconfargs=(
		$(use_enable debug)
	)

	autotools-utils_src_configure
}
