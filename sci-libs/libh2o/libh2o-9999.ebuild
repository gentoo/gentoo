# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

AUTOTOOLS_AUTORECONF=yes

inherit autotools-utils git-r3

DESCRIPTION="Library of routines for IF97 water & steam properties"
HOMEPAGE="https://github.com/mgorny/libh2o/"
SRC_URI=""
EGIT_REPO_URI="https://github.com/mgorny/libh2o.git"

LICENSE="BSD"
SLOT="0"
KEYWORDS=""
IUSE="debug static-libs"

DEPEND="virtual/pkgconfig"

src_configure() {
	local myeconfargs=(
		$(use_enable debug)
	)

	autotools-utils_src_configure
}
