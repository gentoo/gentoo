# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit autotools flag-o-matic toolchain-funcs

DESCRIPTION="De novo assembly of whole-genome shotgun microreads"
# see also http://www.broadinstitute.org/software/allpaths-lg/blog/?page_id=12
HOMEPAGE="http://www.broadinstitute.org/science/programs/genome-biology/crd"
SRC_URI="ftp://ftp.broadinstitute.org/pub/crd/ALLPATHS/Release-LG/latest_source_code/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	!sci-biology/allpaths
	!sci-biology/vaal"
DEPEND="
	${RDEPEND}
	dev-libs/boost:="

PATCHES=(
	"${FILESDIR}/${P}_fix-buildsystem.patch"
	"${FILESDIR}/${P}_remove-namespace-std.patch"
)

pkg_pretend() {
	# as of release 44849, GCC 4.7.0 (or higher) is required
	# seems pre gcc-4.7 users must stay with:
	# ftp://ftp.broadinstitute.org/pub/crd/ALLPATHS/Release-LG/latest_source_code/2013/2013-01/allpathslg-44837.tar.gz
	if [[ ${MERGE_TYPE} != binary ]]; then
		tc-is-gcc && [[ $(gcc-version) < 4.7 ]] && \
			die "You need to use gcc >4.7"
	fi
}

pkg_setup() {
	if ! tc-has-openmp; then
		ewarn "OpenMP is not available in your current selected compiler"

		if tc-is-clang; then
			ewarn "OpenMP support in sys-devel/clang is provided by sys-libs/libomp,"
			ewarn "which you will need to build ${CATEGORY}/${PN} with USE=\"openmp\""
		fi

		die "need openmp capable compiler"
	fi
}

src_prepare() {
	default

	eautoreconf
}
