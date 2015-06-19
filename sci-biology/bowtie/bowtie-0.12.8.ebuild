# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-biology/bowtie/bowtie-0.12.8.ebuild,v 1.3 2013/07/27 22:19:25 ago Exp $

EAPI=4

inherit eutils toolchain-funcs

DESCRIPTION="An ultrafast memory-efficient short read aligner"
HOMEPAGE="http://bowtie-bio.sourceforge.net/"
SRC_URI="mirror://sourceforge/bowtie-bio/${P}-src.zip"

LICENSE="Artistic"
SLOT="0"
IUSE=""
KEYWORDS="amd64 x86 ~x64-macos"

DEPEND="app-arch/unzip"
RDEPEND=""

# NB: Bundles code from Maq (http://maq.sf.net) and the SeqAn library (http://www.seqan.de)
# TODO: properly report system CFLAGS in -DCOMPILE_OPTIONS

src_prepare() {
	epatch "${FILESDIR}"/${P}-gcc-47.patch
}

src_compile() {
	unset CFLAGS
	emake \
		CC="$(tc-getCC)" \
		CPP="$(tc-getCXX)" \
		CXX="$(tc-getCXX)" \
		EXTRA_FLAGS="${LDFLAGS}" \
		RELEASE_FLAGS=""
}

src_install() {
	dobin bowtie bowtie-*
	exeinto /usr/share/${PN}/scripts
	doexe scripts/*
	newman MANUAL bowtie.1
	dodoc AUTHORS NEWS TUTORIAL
}
