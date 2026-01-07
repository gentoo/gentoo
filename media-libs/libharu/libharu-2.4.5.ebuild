# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="C/C++ library for PDF generation"
HOMEPAGE="http://www.libharu.org/"
SRC_URI="https://github.com/${PN}/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="ZLIB"
SLOT="0/${PV%.*}"
KEYWORDS="amd64 ~arm ~arm64 ppc ~ppc64 ~riscv x86"

DEPEND="
	media-libs/libpng:=
	virtual/zlib:=
"
RDEPEND="${DEPEND}"

src_configure() {
	local mycmakeargs=(
		-DLIBHPDF_EXAMPLES=NO # Doesn't work
	)
	cmake_src_configure
}
