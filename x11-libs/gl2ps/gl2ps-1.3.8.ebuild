# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4
inherit cmake-utils multilib

DESCRIPTION="OpenGL to PostScript printing library"
HOMEPAGE="http://www.geuz.org/gl2ps/"
SRC_URI="http://geuz.org/${PN}/src/${P}.tgz"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm hppa ppc ppc64 x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos"
IUSE="doc png zlib"

RDEPEND="
	media-libs/freeglut
	x11-libs/libXmu
	png? ( media-libs/libpng )
	zlib? ( sys-libs/zlib )"
DEPEND="${RDEPEND}
	doc? (
		dev-tex/tth
		dev-texlive/texlive-latex
		dev-texlive/texlive-latexrecommended )"

S=${WORKDIR}/${P}-source

PATCHES=( "${FILESDIR}"/${P}-cmake.patch )

src_configure() {
	local mycmakeargs=(
		-DCMAKE_INSTALL_DOCDIR="share/doc/${PF}"
		$(cmake-utils_use_enable png PNG)
		$(cmake-utils_use_enable zlib ZLIB)
		$(cmake-utils_use_enable doc DOC)
	)
	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install
	if [[ ${CHOST} == *-darwin* ]] ; then
		install_name_tool \
			-id "${EPREFIX}"/usr/$(get_libdir)/libgl2ps.dylib \
			"${D%/}${EPREFIX}"/usr/$(get_libdir)/libgl2ps.dylib || die
	fi
}
