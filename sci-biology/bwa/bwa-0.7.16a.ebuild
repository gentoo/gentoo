# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="Burrows-Wheeler Alignment Tool, a fast short genomic sequence aligner"
HOMEPAGE="https://bio-bwa.sourceforge.net/"
SRC_URI="mirror://sourceforge/bio-bwa/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~x64-macos"

RDEPEND="dev-lang/perl"

PATCHES=(
	"${FILESDIR}"/${PN}-0.7.15-Makefile.patch
	"${FILESDIR}"/${PN}-0.7.16a-gcc-10.patch
)
DOCS=( NEWS.md README-alt.md README.md )

src_configure() {
	tc-export CC AR
}

src_install() {
	dobin bwa

	exeinto /usr/libexec/${PN}
	doexe qualfa2fq.pl xa2multi.pl

	einstalldocs
	doman bwa.1
}
