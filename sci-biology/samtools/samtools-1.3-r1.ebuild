# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 )

inherit autotools python-r1 toolchain-funcs

DESCRIPTION="Utilities for analysing and manipulating the SAM/BAM alignment formats"
HOMEPAGE="http://www.htslib.org/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux ~x64-macos"
IUSE="examples"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="sys-libs/ncurses:0=
	=sci-libs/htslib-${PV}*
	dev-lang/perl
	${PYTHON_DEPS}"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}/${P}-buildsystem.patch"
	"${FILESDIR}/${P}-ncurses.patch"
)

src_prepare() {
	default

	# unbundle libs
	find htslib-* -delete || die

	sed -i -e 's~/software/bin/python~/usr/bin/env python~' "${S}"/misc/varfilter.py || die
	sed -i -e '/htslib.mk/d' -i Makefile || die

	tc-export CC AR

	rm -f aclocal.m4 || die
	eautoreconf
}

src_compile() {
	local mymakeargs=(
		LIBCURSES="$($(tc-getPKG_CONFIG) --libs ncurses)"
		HTSDIR="${EPREFIX}/usr/include"
		HTSLIB=$($(tc-getPKG_CONFIG) --libs htslib)
		BAMLIB="libbam.so"
		libdir=/usr/$(get_libdir)
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

	python_replicate_script "${ED}"usr/bin/varfilter.py

	# fix perl shebangs
	pushd "${ED}"usr/bin/ >> /dev/null
		local i
		for i in plot-bamstats *.pl; do
			sed -e '1s:.*:#!/usr/bin/env perl:' -i "${i}" || die
		done

		# remove lua scripts
		rm -f r2plot.lua vcfutils.lua || die
	popd >> /dev/null

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
