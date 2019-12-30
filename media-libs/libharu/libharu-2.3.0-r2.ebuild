# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CMAKE_ECLASS=cmake
MYP=RELEASE_${PV//./_}
inherit cmake-multilib

DESCRIPTION="C/C++ library for PDF generation"
HOMEPAGE="http://www.libharu.org/"
SRC_URI="https://github.com/${PN}/${PN}/archive/${MYP}.tar.gz -> ${P}.tar.gz"

LICENSE="ZLIB"
SLOT="0/${PV}"
KEYWORDS="amd64 ppc ~ppc64 x86 ~amd64-linux ~x86-linux"
IUSE=""

DEPEND="
	media-libs/libpng:0=[${MULTILIB_USEDEP}]
	sys-libs/zlib:=[${MULTILIB_USEDEP}]
"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}-${MYP}"

PATCHES=(
	"${FILESDIR}"/${P}-1-Included-necessary-char-widths-in-generated-PDF.patch
	"${FILESDIR}"/${P}-2-Avoid-issue-with-libtiff-duplicate-symbols.patch
	"${FILESDIR}"/${P}-3-cmake-fixes.patch
	"${FILESDIR}"/${P}-4-Add-support-for-free-form-triangle-Shading-objects.patch
)

multilib_src_configure() {
	local mycmakeargs=(
		-DLIBHPDF_EXAMPLES=NO # Doesn't work
		-DLIBHPDF_STATIC=NO
	)
	cmake_src_configure
}
