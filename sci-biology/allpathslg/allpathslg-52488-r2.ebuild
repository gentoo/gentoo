# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools flag-o-matic toolchain-funcs

DESCRIPTION="De novo assembly of whole-genome shotgun microreads"
# see also http://www.broadinstitute.org/software/allpaths-lg/blog/?page_id=12
HOMEPAGE="http://www.broadinstitute.org/science/programs/genome-biology/crd"
SRC_URI="ftp://ftp.broadinstitute.org/pub/crd/ALLPATHS/Release-LG/latest_source_code/${P}.tar.gz
	https://dev.gentoo.org/~mgorny/dist/${P}-patchset.tar.bz2"

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
	"${WORKDIR}"/${P}-patchset/${P}_fix-buildsystem.patch
	"${WORKDIR}"/${P}-patchset/${P}_remove-namespace-std.patch
	"${FILESDIR}"/${P}-gcc7.patch
)

pkg_pretend() {
	[[ ${MERGE_TYPE} != binary ]] && tc-check-openmp
}

pkg_setup() {
	[[ ${MERGE_TYPE} != binary ]] && tc-check-openmp
}

src_prepare() {
	default

	# Fix building with glibc-2.27, bug #647340
	sed -i -e 's/-mieee-fp//' configure.ac || die

	eautoreconf
}
