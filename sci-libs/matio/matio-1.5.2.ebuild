# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

AUTOTOOLS_AUTORECONF=1

inherit autotools-utils eutils

DESCRIPTION="Library for reading and writing matlab files"
HOMEPAGE="https://sourceforge.net/projects/matio/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

SLOT="0"
LICENSE="BSD-2"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="doc examples hdf5 sparse static-libs"

RDEPEND="
	sys-libs/zlib
	hdf5? ( sci-libs/hdf5 )"
DEPEND="${RDEPEND}
	doc? ( virtual/latex-base )"

PATCHES=( "${FILESDIR}"/${PN}-1.5.0-asneeded.patch )

src_configure() {
	local myeconfargs=(
		--docdir="${EPREFIX}/usr/share/doc/${PF}"
		$(use_enable hdf5 mat73)
		$(use_enable sparse extended-sparse)
	)
	autotools-utils_src_configure
}

src_compile() {
	autotools-utils_src_compile
	use doc && 	autotools-utils_src_compile -C documentation pdf
}

src_install() {
	use doc && DOCS=( "${BUILD_DIR}"/documentation/matio_user_guide.pdf )
	autotools-utils_src_install
	if use examples; then
		docinto examples
		dodoc test/test*
		insinto /usr/share/${PN}
		doins share/test*
	fi
}
