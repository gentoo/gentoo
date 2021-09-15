# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit multilib toolchain-funcs

DESCRIPTION="Utilities for analysing and manipulating the SAM/BAM alignment formats"
HOMEPAGE="http://samtools.sourceforge.net/"
SRC_URI="https://github.com/samtools/samtools/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0.1-legacy"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux ~x64-macos"

RDEPEND="
	sys-libs/ncurses:0=
	dev-lang/perl"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=( "${FILESDIR}"/${P}-buildsystem.patch )

src_prepare() {
	default
	tc-export CC AR
}

src_compile() {
	local _ncurses="$($(tc-getPKG_CONFIG) --libs ncurses)"
	emake dylib LIBCURSES="${_ncurses}"
	emake LIBCURSES="${_ncurses}"
}

src_install() {
	# install executables and hide them away from sight
	dobin samtools bcftools/{bcftools,vcfutils.pl} misc/{*.py,*.pl,wgsim,ace2sam} \
		misc/{md5sum-lite,maq2sam-short,bamcheck,maq2sam-long,md5fa,plot-bamcheck}
	mv "${ED}"/usr/{bin,${PN}-${SLOT}} || die
	mkdir "${ED}"/usr/bin || die
	mv "${ED}"/usr/{${PN}-${SLOT},bin/} || die

	# remove py2 script, has been removed upstream anyways
	# https://github.com/samtools/samtools/issues/1125
	rm "${ED}"/usr/bin/${PN}-${SLOT}/varfilter.py || die

	# fix perl shebangs
	pushd "${ED}"/usr/bin/${PN}-${SLOT} >/dev/null || die
		local i
		for i in plot-bamcheck *.pl; do
			sed -e '1s:.*:#!/usr/bin/env perl:' -i "${i}" || die
		done
	popd >/dev/null || die

	dolib.so libbam-${SLOT}$(get_libname 1)
	dosym libbam-${SLOT}$(get_libname 1) /usr/$(get_libdir)/libbam-${SLOT}$(get_libname)

	insinto /usr/include/bam-${SLOT}
	doins *.h

	mv ${PN}{,-${SLOT}}.1 || die
	doman ${PN}-${SLOT}.1
	einstalldocs

	dodoc -r examples
	docompress -x /usr/share/doc/${PF}/examples
}

pkg_postinst() {
	elog "This version of samtools should *not* be your first choice for working"
	elog "with NGS data. It is installed solely for programs requiring it."
	elog "It is recommended that you use >=sci-biology/samtools-1.10."
}
