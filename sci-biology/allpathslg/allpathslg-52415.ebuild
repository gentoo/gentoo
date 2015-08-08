# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

AUTOTOOLS_AUTORECONF=true

inherit autotools-utils flag-o-matic

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
	sci-biology/vaal"
RDEPEND=""

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
	local i
	sed \
		-e 's/-ggdb//' \
		-e 's:CEHCK:CHECK:g' \
		-i configure.ac || die
	for i in QueryLookupTable ScaffoldAccuracy MakeLookupTable Fastb ShortQueryLookup; do
		sed -e "/bin_PROGRAMS/s: ${i} : :g" -i src/Makefile.am || die
	done
	autotools-utils_src_prepare
}

src_configure() {
	local myeconfargs=(
		$(use_enable openmp)
	)
	autotools-utils_src_configure
}
