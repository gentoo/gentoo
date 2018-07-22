# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils

DESCRIPTION="Encode/decode WOFF2 font format"
HOMEPAGE="https://github.com/google/woff2"
SRC_URI="https://github.com/google/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~sparc"
IUSE=""

RDEPEND="app-arch/brotli"
DEPEND="${RDEPEND}
	virtual/pkgconfig
"

src_configure() {
	local mycmakeargs=(
		# needed, causes QA warnings otherwise
		-DCMAKE_SKIP_RPATH=ON
	)
	cmake-utils_src_configure
}
