# Copyright 2021-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..10} )

inherit python-single-r1 toolchain-funcs

DESCRIPTION="Popular short read aligner for Next-generation sequencing data"
HOMEPAGE="http://bowtie-bio.sourceforge.net/bowtie2/"
SRC_URI="mirror://sourceforge/project/${PN}-bio/bowtie2/${PV}/bowtie2-${PV}-source.zip"
S="${WORKDIR}/${PN}2-${PV}"

LICENSE="GPL-3"
SLOT="2"
KEYWORDS="~amd64 ~x86"
IUSE="cpu_flags_x86_sse2 examples"
REQUIRED_USE="cpu_flags_x86_sse2 ${PYTHON_REQUIRED_USE}"

RDEPEND="
	${PYTHON_DEPS}
	dev-lang/perl
	sys-libs/zlib"
DEPEND="${RDEPEND}"
BDEPEND="app-arch/unzip"

src_compile() {
	emake \
		CXX="$(tc-getCXX)" \
		CXXFLAGS="" \
		CPPFLAGS="${CPPFLAGS}" \
		EXTRA_FLAGS="${LDFLAGS}" \
		RELEASE_FLAGS="${CXXFLAGS} -msse2"
}

src_install() {
	dobin bowtie2 bowtie2-*

	exeinto /usr/libexec/bowtie2
	doexe scripts/*

	HTML_DOCS=( doc/{manual.html,style.css} )
	einstalldocs
	dodoc TUTORIAL
	newman MANUAL bowtie2.1

	python_fix_shebang "${ED}"/usr/bin/bowtie2-{build,inspect}

	if use examples; then
		docinto examples
		dodoc -r example/.
		docompress -x /usr/share/doc/${PF}/examples
	fi
}
