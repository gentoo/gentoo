# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-biology/tophat/tophat-1.4.1.ebuild,v 1.2 2012/04/25 16:39:53 jlec Exp $

EAPI=4

inherit flag-o-matic autotools

DESCRIPTION="A fast splice junction mapper for RNA-Seq reads"
HOMEPAGE="http://tophat.cbcb.umd.edu/"
SRC_URI="http://tophat.cbcb.umd.edu/downloads/${P}.tar.gz"

LICENSE="Artistic"
SLOT="0"
IUSE="+bam"
KEYWORDS="~amd64 ~x86"

DEPEND="bam? ( sci-biology/samtools )"
RDEPEND="${DEPEND}
	sci-biology/bowtie"

MAKEOPTS="${MAKEOPTS} -j1"

src_prepare() {
	filter-ldflags -Wl,--as-needed
	eautoreconf
}

src_configure() {
	econf \
		$(use_with bam)
}
