# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils

DESCRIPTION="Binary-decimal and decimal-binary conversion routines for IEEE doubles"
HOMEPAGE="https://github.com/google/double-conversion"
SRC_URI="https://github.com/google/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0/1"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~mips ~ppc ~ppc64 ~sparc ~x86 ~amd64-linux ~x86-linux"
IUSE="test"

src_configure() {
	local mycmakeargs=(
		-DBUILD_SHARED_LIBS=ON
		-DBUILD_TESTING=$(usex test)
	)
	cmake-utils_src_configure
}
