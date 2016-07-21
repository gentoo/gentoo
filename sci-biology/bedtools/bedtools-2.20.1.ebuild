# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit flag-o-matic

DESCRIPTION="Tools for manipulation and analysis of BED, GFF/GTF, VCF, and SAM/BAM file formats"
HOMEPAGE="https://github.com/arq5x/bedtools2"
SRC_URI="https://github.com/arq5x/bedtools2/releases/download/v${PV}/bedtools-${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

S="${WORKDIR}/bedtools2-${PV}"

src_prepare() {
	filter-ldflags -Wl,--as-needed
	sed -i \
		-e '/export CXXFLAGS/ d' \
		-e '/export CXX/ d' \
		Makefile || die
}

src_install() {
	dobin bin/*
	dodoc README* RELEASE_HISTORY
	insinto /usr/share/${PN}
	doins -r genomes
}
