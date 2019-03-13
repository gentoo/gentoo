# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit cmake-utils

DESCRIPTION="A multicast protocol to support Bible software shared co-navigation"
HOMEPAGE="http://www.crosswire.org/wiki/BibleSync"
SRC_URI="https://github.com/karlkleinpaste/biblesync/releases/download/${PV}/${P}.tar.gz"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~amd64"
IUSE="static"

DEPEND="dev-util/cmake"
RDEPEND=""

src_configure() {
	local mycmakeargs=(
		"-DBUILD_SHARED_LIBS=$(usex !static)"
		"-DLIBDIR=/usr/$(get_libdir)"
	)
	cmake-utils_src_configure
}
