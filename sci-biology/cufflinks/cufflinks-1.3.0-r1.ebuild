# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-biology/cufflinks/cufflinks-1.3.0-r1.ebuild,v 1.3 2015/01/08 07:35:53 jlec Exp $

EAPI=5

AUTOTOOLS_AUTORECONF=yes

inherit autotools-utils

DESCRIPTION="Transcript assembly, differential expression, and differential regulation for RNA-Seq"
HOMEPAGE="http://cufflinks.cbcb.umd.edu/"
SRC_URI="http://cufflinks.cbcb.umd.edu/downloads/${P}.tar.gz"

SLOT="0"
LICENSE="Artistic"
IUSE="debug"
KEYWORDS="~amd64 ~x86"

DEPEND="
	>=sci-biology/samtools-0.1.18
	<sci-biology/samtools-1
	<dev-libs/boost-1.56:="
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}"/${P}-autotools.patch
	"${FILESDIR}"/${P}-boost.patch
	"${FILESDIR}"/${P}-gcc-4.7.patch
	)

src_configure() {
	local myeconfargs=(
		--disable-optim
		--with-boost-libdir="${EPREFIX}/usr/$(get_libdir)/"
		--with-bam="${EPREFIX}/usr/"
		$(use_enable debug)
	)
	autotools-utils_src_configure
}
