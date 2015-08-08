# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit flag-o-matic

DESCRIPTION="Tools for manipulation and analysis of BED, GFF/GTF, VCF, and SAM/BAM file formats"
HOMEPAGE="http://code.google.com/p/bedtools/"
SRC_URI="http://bedtools.googlecode.com/files/BEDTools.v${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

S="${WORKDIR}/BEDTools-Version-${PV}"

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
