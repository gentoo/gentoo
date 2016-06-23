# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DESCRIPTION="Library for reading and writing matlab files"
HOMEPAGE="http://sourceforge.net/projects/matio/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

SLOT="0"
LICENSE="BSD-2"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="doc examples hdf5 sparse static-libs"

RDEPEND="
	sys-libs/zlib
	hdf5? ( sci-libs/hdf5 )"
DEPEND="${RDEPEND}
	sys-devel/libtool
	doc? ( virtual/latex-base )"

src_configure() {
	econf \
		$(use_enable hdf5 mat73) \
		$(use_enable sparse extended-sparse)
}

src_compile() {
	default
	use doc && emake -C documentation pdf
}

src_install() {
	default
	use doc && dodoc documentation/matio_user_guide.pdf
	if use examples; then
		docinto examples
		dodoc test/test*
		insinto /usr/share/${PN}
		doins share/test*
	fi
}
