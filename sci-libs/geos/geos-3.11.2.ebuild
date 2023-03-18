# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Geometry engine library for Geographic Information Systems"
HOMEPAGE="https://libgeos.org/"
SRC_URI="https://download.osgeo.org/geos/${P}.tar.bz2"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ia64 ~ppc ~ppc64 ~riscv ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris"
IUSE="doc test"
RESTRICT="!test? ( test )"

BDEPEND="doc? ( app-doc/doxygen )"

PATCHES=(
	"${FILESDIR}"/${P}-gcc-13.patch
)

src_configure() {
	local mycmakeargs=(
		-DBUILD_DOCUMENTATION=$(usex doc)
		-DBUILD_TESTING=$(usex test)
		-DUSE_CCACHE=OFF

		# bug #709368
		$(usev arm '-DDISABLE_GEOS_INLINE=ON')
	)

	cmake_src_configure
}

src_compile() {
	cmake_src_compile

	use doc && cmake_src_compile docs
}

src_install() {
	cmake_src_install

	if use doc ; then
		HTML_DOCS=( "${BUILD_DIR}"/doxygen/doxygen_docs/html/. )
		einstalldocs
	fi
}
