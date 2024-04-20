# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit libtool

DESCRIPTION="Library for reading and writing matlab files"
HOMEPAGE="https://sourceforge.net/projects/matio/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0/11" # subslot = soname version
KEYWORDS="amd64 ~arm64 ~x86 ~amd64-linux ~x86-linux"
IUSE="doc examples hdf5 sparse"

RDEPEND="
	sys-libs/zlib
	hdf5? ( sci-libs/hdf5:= )"
DEPEND="${RDEPEND}"
BDEPEND="doc? ( virtual/latex-base )"

src_prepare() {
	default
	elibtoolize
}

src_configure() {
	econf \
		--disable-static \
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
		dodoc test/test*.c
		insinto /usr/share/${PN}
		doins share/test*
	fi

	# no static archives
	find "${ED}" -name "*.la" -delete || die
}
