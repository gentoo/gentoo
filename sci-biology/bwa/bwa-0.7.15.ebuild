# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit toolchain-funcs

DESCRIPTION="Burrows-Wheeler Alignment Tool, a fast short genomic sequence aligner"
HOMEPAGE="http://bio-bwa.sourceforge.net/"
SRC_URI="mirror://sourceforge/bio-bwa/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
IUSE=""
KEYWORDS="~amd64 ~x86 ~x64-macos"

RDEPEND="dev-lang/perl"

DOCS=( NEWS.md README-alt.md README.md )
PATCHES=( "${FILESDIR}"/${P}-Makefile.patch )

src_configure() {
	tc-export CC AR
	default
}

src_install() {
	dobin bwa

	doman bwa.1

	exeinto /usr/libexec/${PN}
	doexe qualfa2fq.pl xa2multi.pl

	einstalldocs
}
