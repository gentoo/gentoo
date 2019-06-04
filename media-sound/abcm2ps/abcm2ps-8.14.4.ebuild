# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="Program to convert abc files to Postscript files"
HOMEPAGE="https://github.com/leesavide/abcm2ps"
SRC_URI="https://github.com/leesavide/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
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
