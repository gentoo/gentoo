# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="C/C++ library for PDF generation"
HOMEPAGE="http://www.libharu.org/"
SRC_URI="https://github.com/${PN}/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="ZLIB"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux"

DEPEND="
	media-libs/libpng:=
	sys-libs/zlib:=
"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}"/${PN}-2.3.0-1-Included-necessary-char-widths-in-generated-PDF.patch
)

src_configure() {
	local mycmakeargs=(
		-DLIBHPDF_EXAMPLES=NO # Doesn't work
		-DLIBHPDF_STATIC=NO
	)
	cmake_src_configure
}
