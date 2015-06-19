# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-biology/bowtie/bowtie-1.0.0.ebuild,v 1.2 2013/09/18 06:50:27 jlec Exp $

EAPI=5

inherit eutils toolchain-funcs

DESCRIPTION="An ultrafast memory-efficient short read aligner"
HOMEPAGE="http://bowtie-bio.sourceforge.net/"
SRC_URI="mirror://sourceforge/bowtie-bio/${P}-src.zip"

LICENSE="Artistic"
SLOT="0"
IUSE=""
KEYWORDS="~amd64 ~x86 ~x64-macos"

DEPEND="app-arch/unzip"
RDEPEND=""

src_compile() {
	unset CFLAGS
	emake \
		CC="$(tc-getCC)" \
		CPP="$(tc-getCXX)" \
		CXX="$(tc-getCXX)" \
		EXTRA_FLAGS="${LDFLAGS}" \
		RELEASE_FLAGS="${CXXFLAGS}"
}

src_install() {
	dobin bowtie bowtie-*
	exeinto /usr/share/${PN}/scripts
	doexe scripts/*

	insinto /usr/share/${PN}
	doins -r genomes indexes

	newman MANUAL bowtie.1
	dodoc AUTHORS NEWS TUTORIAL doc/README
	dohtml doc/{manual.html,style.css}
}
