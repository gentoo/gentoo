# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-biology/allpathslg/allpathslg-47093.ebuild,v 1.4 2015/03/31 09:35:15 jlec Exp $

EAPI=5

inherit autotools eutils flag-o-matic

DESCRIPTION="De novo assembly of whole-genome shotgun microreads"
HOMEPAGE="http://www.broadinstitute.org/science/programs/genome-biology/crd"
SRC_URI="ftp://ftp.broadinstitute.org/pub/crd/ALLPATHS/Release-LG/latest_source_code/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
IUSE=""
KEYWORDS="~amd64 -x86"

DEPEND="
	dev-libs/boost
	!sci-biology/allpaths
	sci-biology/vaal"
RDEPEND=""

src_prepare() {
	epatch "${FILESDIR}"/${P}-gcc4.9.patch
	sed -i 's/-ggdb//' configure.ac || die
	eautoreconf
}

src_install() {
	default
	# Provided by sci-biology/vaal
	for i in QueryLookupTable ScaffoldAccuracy MakeLookupTable Fastb ShortQueryLookup; do
		rm "${ED}/usr/bin/$i" || die
	done
}
