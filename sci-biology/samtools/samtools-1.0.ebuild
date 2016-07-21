# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit eutils multilib python-r1 toolchain-funcs

DESCRIPTION="Utilities for analysing and manipulating the SAM/BAM alignment formats"
HOMEPAGE="http://www.htslib.org/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux ~x64-macos"
IUSE="examples"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

CDEPEND="
	sys-libs/ncurses:0=
	sci-libs/htslib"

RDEPEND="${CDEPEND}
	dev-lang/lua
	dev-lang/perl"
DEPEND="${CDEPEND}
	virtual/pkgconfig"

src_prepare() {
	find htslib-1.0 -delete || die

	sed -i 's~/software/bin/python~/usr/bin/env python~' "${S}"/misc/varfilter.py || die

	tc-export CC AR

	sed \
		-e '/htslib.mk/d' \
		-i Makefile || die

}

src_compile() {
	local mymakeargs=(
		LIBCURSES="$($(tc-getPKG_CONFIG) --libs ncurses)"
		CC="$(tc-getCC)"
		LDFLAGS="${LDFLAGS}"
		CFLAGS="${CFLAGS}"
		HTSDIR="${EPREFIX}/usr/include"
		HTSLIB=$($(tc-getPKG_CONFIG) --libs htslib)
		)
	emake "${mymakeargs[@]}"
}

src_install() {
	dobin samtools $(find misc -type f -executable)

	python_replicate_script "${ED}"/usr/bin/varfilter.py

	doman ${PN}.1
	dodoc AUTHORS NEWS README

	if use examples; then
		insinto /usr/share/${PN}
		doins -r examples
	fi
}
