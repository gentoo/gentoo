# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

FORTRAN_NEEDED=plugins

inherit autotools flag-o-matic fortran-2

DESCRIPTION="Fast implementation of several recombination jet algorithms"
HOMEPAGE="http://www.fastjet.fr/"
SRC_URI="http://www.fastjet.fr/repo/${P}.tar.gz"

LICENSE="GPL-2 QPL"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="cgal doc examples +plugins"

RDEPEND="
	cgal? ( sci-mathematics/cgal:= )
	plugins? ( sci-physics/siscone:= )"
DEPEND="${RDEPEND}"
BDEPEND="doc? ( app-doc/doxygen[dot] )"

PATCHES=( "${FILESDIR}"/${P}-system-siscone.patch )

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	use cgal && \
		has_version 'sci-mathematics/cgal[gmp]' && append-libs -lgmp

	econf \
		--disable-static \
		$(use_enable cgal) \
		$(use_enable plugins allplugins) \
		$(use_enable plugins allcxxplugins)
}

src_compile() {
	default

	if use doc; then
		doxygen Doxyfile || die
		HTML_DOCS=( html/. )
	fi
}

src_install() {
	default

	if use examples; then
		emake -C example maintainer-clean
		find example -iname 'makefile*' -delete || die

		docinto examples
		dodoc -r example/.
		docompress -x /usr/share/doc/${PF}/examples
	fi

	# no static archives
	find "${ED}" -name '*.la' -delete || die
}
