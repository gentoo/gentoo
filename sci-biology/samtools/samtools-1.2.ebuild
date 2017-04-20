# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

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
	>=sci-libs/htslib-${PV}"

RDEPEND="${CDEPEND}
	dev-lang/lua
	dev-lang/perl
	${PYTHON_DEPS}"
DEPEND="${CDEPEND}
	virtual/pkgconfig"

src_prepare() {
	find htslib-* -delete || die

	sed -i 's~/software/bin/python~/usr/bin/env python~' "${S}"/misc/varfilter.py || die

	epatch "${FILESDIR}"/${P}-buildsystem.patch

	tc-export CC AR

	sed \
		-e '/htslib.mk/d' \
		-i Makefile || die

}

src_compile() {
	local mymakeargs=(
		LIBCURSES="$($(tc-getPKG_CONFIG) --libs ncurses)"
		HTSDIR="${EPREFIX}/usr/include"
		HTSLIB=$($(tc-getPKG_CONFIG) --libs htslib)
		BAMLIB="libbam.so"
		)
	emake "${mymakeargs[@]}"
}

src_test() {
	local mymakeargs=(
		LIBCURSES="$($(tc-getPKG_CONFIG) --libs ncurses)"
		HTSDIR="${EPREFIX}/usr/include"
		HTSLIB=$($(tc-getPKG_CONFIG) --libs htslib)
		BAMLIB="libbam.so"
		)
	LD_LIBRARY_PATH="${S}" emake "${mymakeargs[@]}" test
}

src_install() {
	dobin samtools $(find misc -type f -executable)

	python_replicate_script "${ED}"/usr/bin/varfilter.py
	dolib.so libbam.so*

	insinto /usr/include/bam
	doins *.h

	doman ${PN}.1
	dodoc AUTHORS NEWS README

	if use examples; then
		insinto /usr/share/${PN}
		doins -r examples
	fi
}
