# Copyright 2022-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CMAKE_IN_SOURCE_BUILD=1
inherit cmake toolchain-funcs flag-o-matic

DESCRIPTION="Fuzzy matching library"
HOMEPAGE="https://github.com/trendmicro/tlsh"
SRC_URI="https://github.com/trendmicro/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="|| ( Apache-2.0 BSD )"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ia64 ~ppc ~ppc64 ~x86"

PATCHES=(
	"${FILESDIR}"/${P}-big-endian.patch
	"${FILESDIR}"/${P}-gnuinstalldirs.patch
	"${FILESDIR}"/${P}-respect-flags.patch
)

src_prepare() {
	# https://github.com/trendmicro/tlsh/issues/131
	[[ "$(tc-endian)" == "big" ]] && append-flags "-D__SPARC"
	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DTLSH_CHECKSUM_1B=1
		-DTLSH_SHARED_LIBRARY=1
	)
	cmake_src_configure
}

src_install() {
	cmake_src_install
	find "${ED}" -name '*.a' -delete || die # Remove the static lib
}
