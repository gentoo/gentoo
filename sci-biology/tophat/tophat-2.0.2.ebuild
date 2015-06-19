# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-biology/tophat/tophat-2.0.2.ebuild,v 1.1 2012/07/19 12:03:38 jlec Exp $

EAPI=4

AUTOTOOLS_AUTORECONF=yes

inherit autotools-utils

DESCRIPTION="A fast splice junction mapper for RNA-Seq reads"
HOMEPAGE="http://tophat.cbcb.umd.edu/"
SRC_URI="http://tophat.cbcb.umd.edu/downloads/${P}.tar.gz"

LICENSE="Artistic"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+bam debug"

DEPEND="
	dev-libs/boost
	bam? ( sci-biology/samtools )"
RDEPEND="${DEPEND}
	sci-biology/bowtie"

PATCHES=( "${FILESDIR}"/${P}-flags.patch )

src_configure() {
	local myeconfargs=( $(use_enable debug) )
	autotools-utils_src_configure
}
