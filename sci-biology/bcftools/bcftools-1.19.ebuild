# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} )

inherit python-single-r1

DESCRIPTION="Utilities for variant calling and manipulating VCF and BCF files"
HOMEPAGE="http://www.htslib.org"
SRC_URI="https://github.com/samtools/${PN}/releases/download/${PV}/${P}.tar.bz2"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="
	dev-lang/perl
	$(python_gen_cond_dep 'dev-python/matplotlib[${PYTHON_USEDEP}]')
	=sci-libs/htslib-$(ver_cut 1-2)*:=
	sys-libs/zlib
	${PYTHON_DEPS}"
DEPEND="${RDEPEND}"
BDEPEND="${PYTHON_DEPS}"

src_prepare() {
	default

	python_fix_shebang misc/{gff2gff,guess-ploidy,plot-roh}.py

	# remove bundled htslib
	rm -r htslib-* || die
}

src_configure() {
	econf \
		--disable-bcftools-plugins \
		--disable-libgsl \
		--with-htslib=system
}
