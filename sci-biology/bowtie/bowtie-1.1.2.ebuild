# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils toolchain-funcs

DESCRIPTION="Popular short read aligner for Next-generation sequencing data"
HOMEPAGE="http://bowtie-bio.sourceforge.net/"
SRC_URI="mirror://sourceforge/bowtie-bio/${P}-src.zip"

LICENSE="Artistic"
SLOT="1"
KEYWORDS="~amd64 ~x86 ~x64-macos"

IUSE="examples +tbb"

DEPEND="app-arch/unzip
	tbb? ( dev-cpp/tbb )"
RDEPEND=""

DOCS=( AUTHORS NEWS TUTORIAL doc/README )
HTML_DOCS=( doc/{manual.html,style.css} )

src_prepare() {
	# always include tinythread.cpp
	epatch "${FILESDIR}/${P}-tbb-tinythread-missing.patch"
}

src_compile() {
	emake \
		CC="$(tc-getCC)" \
		CPP="$(tc-getCXX)" \
		CFLAGS="" \
		CXXFLAGS="" \
		EXTRA_FLAGS="${LDFLAGS}" \
		RELEASE_FLAGS="${CXXFLAGS}" \
		WITH_TBB="$(usex tbb 1 0)"
}

src_install() {
	dobin ${PN} ${PN}-*

	exeinto /usr/libexec/${PN}
	doexe scripts/*

	newman MANUAL ${PN}.1
	einstalldocs

	if use examples; then
		insinto /usr/share/${PN}
		doins -r genomes indexes
	fi
}
