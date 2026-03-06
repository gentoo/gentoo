# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="C/C++ library for PDF generation"
HOMEPAGE="http://www.libharu.org/"
SRC_URI="https://github.com/${PN}/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

# demo/type1/COPYING is a copy of the GPLv2
LICENSE="ZLIB examples? ( GPL-2 )"
SLOT="0/${PV%.*}"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~riscv ~x86"
IUSE="examples"

DEPEND="
	media-libs/libpng:=
	virtual/zlib:=
"
RDEPEND="${DEPEND}"

PATCHES="${FILESDIR}/${P}-docdir.patch"

src_prepare() {
	cmake_src_prepare

	# We don't build these, and it will be convenient later to dodoc the
	# entire directory if USE=examples is set. Leave demo/type1/COPYING
	# to identify the sole directory that is not under a ZLIB license.
	rm demo/CMakeLists.txt || die
	mv demo examples || die
}

src_configure() {
	local mycmakeargs=(
		-DLIBHPDF_EXAMPLES=NO # Doesn't work
	)
	cmake_src_configure
}

src_install() {
	# README.md and CHANGES are handled by the build system,
	# and we don't want README_cmake.
	DOCS=()
	cmake_src_install
	use examples && dodoc -r examples
}
