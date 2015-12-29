# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit autotools eutils flag-o-matic

DESCRIPTION="De novo assembly of whole-genome shotgun microreads"
# see also http://www.broadinstitute.org/software/allpaths-lg/blog/?page_id=12
HOMEPAGE="http://www.broadinstitute.org/science/programs/genome-biology/crd"
SRC_URI="ftp://ftp.broadinstitute.org/pub/crd/ALLPATHS/Release-LG/latest_source_code/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="openmp"

DEPEND="
	dev-libs/boost
	!sci-biology/allpaths
	!sci-biology/vaal"
RDEPEND=""

PATCHES=("${FILESDIR}/${P}_fix-buildsystem.patch" "${FILESDIR}/${P}_remove-namespace-std.patch")

pkg_pretend() {
	# as of release 44849, GCC 4.7.0 (or higher) is required
	# seems pre gcc-4.7 users must stay with:
	# ftp://ftp.broadinstitute.org/pub/crd/ALLPATHS/Release-LG/latest_source_code/2013/2013-01/allpathslg-44837.tar.gz
	if [[ ${MERGE_TYPE} != binary ]]; then
		[[ $(tc-getCC) == *gcc* ]] && [[ $(gcc-version) < 4.7 ]] && \
		die "You need to use gcc >4.7"
	fi
}

src_prepare() {
	default

	eautoreconf
}

src_configure() {
	econf \
		$(use_enable openmp)
}
