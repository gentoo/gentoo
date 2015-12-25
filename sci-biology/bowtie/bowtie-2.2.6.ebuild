# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils toolchain-funcs

DESCRIPTION="Popular short read aligner for Next-generation sequencing data, allowing for gaps"
HOMEPAGE="http://bowtie-bio.sourceforge.net/bowtie2/"
SRC_URI="mirror://sourceforge/project/${PN}-bio/${PN}2/${PV}/${PN}2-${PV}-source.zip"

LICENSE="GPL-3"
SLOT="2"
KEYWORDS="amd64 x86"

IUSE="examples cpu_flags_x86_sse2 +tbb"

RDEPEND="dev-lang/perl"
DEPEND="${RDEPEND}
		app-arch/unzip
		tbb? ( dev-cpp/tbb )"

S="${WORKDIR}/${PN}2-${PV}"

DOCS=( AUTHORS NEWS TUTORIAL )
HTML_DOCS=( doc/{manual.html,style.css} )

pkg_pretend() {
	if ! use cpu_flags_x86_sse2 ; then
		eerror "This package requires a CPU supporting the SSE2 instruction set."
		die "SSE2 support missing"
	fi
}

src_compile() {
	emake \
		CC="$(tc-getCC)" \
		CPP="$(tc-getCXX)" \
		CXX="$(tc-getCXX)" \
		CFLAGS="" \
		CXXFLAGS="" \
		EXTRA_FLAGS="${LDFLAGS}" \
		RELEASE_FLAGS="${CXXFLAGS} -msse2" \
		WITH_TBB="$(usex tbb 1 0)"
}

src_install() {
	dobin ${PN}2 ${PN}2-*

	exeinto /usr/libexec/${PN}2
	doexe scripts/*

	newman MANUAL ${PN}2.1
	einstalldocs

	if use examples; then
		insinto /usr/share/${PN}2
		doins -r example
	fi
}
