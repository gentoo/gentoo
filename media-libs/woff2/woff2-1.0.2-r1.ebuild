# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils

DESCRIPTION="Encode/decode WOFF2 font format"
HOMEPAGE="https://github.com/google/woff2"
SRC_URI="https://github.com/google/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm arm64 ~ia64 ~ppc ~ppc64 ~s390 ~sparc x86 ~amd64-linux ~x86-linux ~x64-macos ~x86-macos ~x64-solaris"
IUSE=""

RDEPEND="app-arch/brotli"
DEPEND="${RDEPEND}
	virtual/pkgconfig
"

src_configure() {
	local mycmakeargs=(
		-DCMAKE_SKIP_RPATH=ON # needed, causes QA warnings otherwise
		-DCANONICAL_PREFIXES=ON #661942
	)
	cmake-utils_src_configure
}
