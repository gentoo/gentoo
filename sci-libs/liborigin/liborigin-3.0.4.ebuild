# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Library for reading OriginLab OPJ project files"
HOMEPAGE="https://sourceforge.net/projects/liborigin/ https://github.com/SciDAVis/liborigin/"
SRC_URI="https://sourceforge.net/projects/${PN}/files/${PN}/$(ver_cut 1-2)/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="2"
KEYWORDS="~amd64 ~x86"
IUSE="debug doc tools"

BDEPEND="
	doc? ( app-text/doxygen )
"
RDEPEND="
	dev-cpp/tree
"
DEPEND="${RDEPEND}"

PATCHES=(
	# add missing header
	"${FILESDIR}/${PN}-3.0.1-missing-header.patch"
	# downstream
	"${FILESDIR}/${PN}-3.0.2-buildsystem.patch" # ENABLE_TOOLS, shared link, doc paths
)

src_prepare() {
	cmake_src_prepare
	rm tree.hh || die "failed to remove bundled tree.hh"

	sed -e "/install.*html/s/liborigin/${PF}/" \
		-i CMakeLists.txt || die "failed to fix htmldoc install path"
}

src_configure() {
	local mycmakeargs=(
		-DGENERATE_CODE_FOR_LOG=$(usex debug)
		$(cmake_use_find_package doc Doxygen)
		-DENABLE_TOOLS=$(usex tools)
		-DBUILD_STATIC_LIBS=OFF
	)
	cmake_src_configure
}

src_compile() {
	cmake_src_compile
	use doc && cmake_src_compile doc
}
