# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=( python{2_7,3_4,3_5} )

inherit flag-o-matic python-any-r1 toolchain-funcs

DESCRIPTION="Tools for manipulation and analysis of BED, GFF/GTF, VCF, SAM/BAM file formats"
HOMEPAGE="https://bedtools.readthedocs.io/"
SRC_URI="https://github.com/arq5x/${PN}2/releases/download/v${PV}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="test"

DEPEND="${PYTHON_DEPS}
	test? (
		sci-libs/htslib
		sci-biology/samtools
	)"
RDEPEND="sys-libs/zlib"

S="${WORKDIR}/${PN}2"

DOCS=( README.md RELEASE_HISTORY )
PATCHES=( "${FILESDIR}/${PN}-2.26.0-fix-buildsystem.patch" )

src_configure() {
	append-lfs-flags
	export prefix="${EPREFIX}/usr"
	tc-export AR CXX
}

src_install() {
	default

	insinto /usr/share/${PN}
	doins -r genomes
}
