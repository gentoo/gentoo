# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit eutils multilib python-r1 toolchain-funcs

DESCRIPTION="Utilities for SAM (Sequence Alignment/Map), a format for large nucleotide sequence alignments"
HOMEPAGE="http://samtools.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux ~x64-macos"
IUSE="examples"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

CDEPEND="sys-libs/ncurses"
RDEPEND="${CDEPEND}
	dev-lang/lua
	dev-lang/perl"
DEPEND="${CDEPEND}
	virtual/pkgconfig"

src_prepare() {
	epatch "${FILESDIR}"/${P}-buildsystem.patch

	sed -i 's~/software/bin/python~/usr/bin/env python~' "${S}"/misc/varfilter.py || die

	tc-export CC AR
}

src_compile() {
	local _ncurses="$($(tc-getPKG_CONFIG) --libs ncurses)"
	emake dylib LIBCURSES="${_ncurses}"
	emake LIBCURSES="${_ncurses}"
}

src_install() {
	dobin samtools $(find bcftools misc -type f -executable)

	python_replicate_script "${ED}"/usr/bin/varfilter.py

	dolib.so libbam$(get_libname 1)
	dosym libbam$(get_libname 1) /usr/$(get_libdir)/libbam$(get_libname)

	insinto /usr/include/bam
	doins *.h

	doman ${PN}.1
	dodoc AUTHORS NEWS

	if use examples; then
		insinto /usr/share/${PN}
		doins -r examples
	fi
}
