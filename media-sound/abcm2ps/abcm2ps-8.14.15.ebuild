# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="Program to convert abc files to Postscript files"
HOMEPAGE="https://github.com/lewdlime/abcm2ps"
SRC_URI="https://github.com/lewdlime/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="examples pango"

BDEPEND="virtual/pkgconfig"
DEPEND="
	pango? (
		media-libs/freetype:2
		x11-libs/pango
	)"
RDEPEND="${DEPEND}"

src_configure() {
	econf \
		--enable-a4 \
		--enable-deco-is-roll \
		$(use_enable pango)
}

src_compile() {
	emake CC="$(tc-getCC)" CFLAGS="${CFLAGS}"
}

src_install() {
	dobin abcm2ps

	insinto /usr/share/${PN}
	doins *.fmt

	dodoc README.md

	if use examples ; then
		docinto examples
		dodoc sample*.*
		docompress -x /usr/share/doc/${PF}/examples
	fi
}
