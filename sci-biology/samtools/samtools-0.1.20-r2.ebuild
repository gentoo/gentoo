# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=( python2_7 )

inherit eutils python-r1 toolchain-funcs

DESCRIPTION="Utilities for analysing and manipulating the SAM/BAM alignment formats"
HOMEPAGE="http://samtools.sourceforge.net/"
SRC_URI="https://github.com/samtools/samtools/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0.1-legacy"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux ~x64-macos"
IUSE="examples"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="sys-libs/ncurses:0=
	dev-lang/perl"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}/${P}-buildsystem.patch"
)

src_prepare() {
	default
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
	mv "${ED}"/usr/{bin,${PN}-${SLOT}} || die
	mkdir "${ED}"/usr/bin || die
	mv "${ED}"/usr/{${PN}-${SLOT},bin/} || die

	mv "${ED}"/usr/bin/${PN}-${SLOT}/varfilter{,-${SLOT}}.py || die
	python_replicate_script "${ED}"/usr/bin/${PN}-${SLOT}/varfilter-${SLOT}.py

	# fix perl shebangs
	pushd "${ED}"usr/bin/"${PN}-${SLOT}"/ >> /dev/null
		local i
		for i in plot-bamcheck *.pl; do
			sed -e '1s:.*:#!/usr/bin/env perl:' -i "${i}" || die
		done

		# remove lua scripts
		rm -f r2plot.lua vcfutils.lua || die
	popd >> /dev/null

	dolib.so libbam-${SLOT}$(get_libname 1)
	dosym libbam-${SLOT}$(get_libname 1) /usr/$(get_libdir)/libbam-${SLOT}$(get_libname)

	insinto /usr/include/bam-${SLOT}
	doins *.h

	mv ${PN}{,-${SLOT}}.1 || die
	doman ${PN}-${SLOT}.1
	dodoc AUTHORS NEWS

	use examples && dodoc -r examples
}

pkg_postinst() {
	elog "This version of samtools should *not* be your first choice for working"
	elog "with NGS data. It is installed solely for programs requiring it."
	elog "It is recommended that you use >=sci-biology/samtools-1.2."
}
