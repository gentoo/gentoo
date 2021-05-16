# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit cmake

DESCRIPTION="OpenGL to PostScript printing library"
HOMEPAGE="http://www.geuz.org/gl2ps/"
SRC_URI="http://geuz.org/${PN}/src/${P}.tgz"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="amd64 arm arm64 ~hppa ppc ppc64 x86 ~amd64-linux ~x86-linux ~ppc-macos"
IUSE="doc png zlib"

RDEPEND="
	media-libs/freeglut
	x11-libs/libXmu
	png? ( media-libs/libpng:0= )
	zlib? ( sys-libs/zlib )"
DEPEND="${RDEPEND}
	doc? (
		dev-tex/tth
		dev-texlive/texlive-latex
		dev-texlive/texlive-latexrecommended )"

PATCHES=( "${FILESDIR}"/${PN}-1.4.2-cmake.patch )

src_prepare() {
	cmake_src_prepare
	sed '/^install.*TODO\.txt/d' -i "${S}"/CMakeLists.txt || die
}

src_configure() {
	local mycmakeargs=(
		-DCMAKE_INSTALL_DOCDIR="share/doc/${PF}"
		-DENABLE_DOC="$(usex doc)"
		-DENABLE_PNG="$(usex png)"
		-DENABLE_ZLIB="$(usex zlib)"
	)
	cmake_src_configure
}

src_install() {
	cmake_src_install
	if [[ ${CHOST} == *-darwin* ]] ; then
		install_name_tool \
			-id "${EPREFIX}"/usr/$(get_libdir)/libgl2ps.dylib \
			"${D}${EPREFIX}"/usr/$(get_libdir)/libgl2ps.dylib || die
	fi
}
