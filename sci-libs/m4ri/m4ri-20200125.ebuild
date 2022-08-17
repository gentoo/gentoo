# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit flag-o-matic toolchain-funcs

DESCRIPTION="Method of four russian for inversion (M4RI)"
HOMEPAGE="https://bitbucket.org/malb/m4ri"
SRC_URI="https://bitbucket.org/malb/${PN}/downloads/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 ppc64 x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos"
IUSE="debug openmp cpu_flags_x86_sse2 png static-libs"

BDEPEND="virtual/pkgconfig"
DEPEND="png? ( media-libs/libpng:= )"
RDEPEND="${DEPEND}"

# NEWS and ChangeLog are empty as of 2020-01-01, and README.md
# didn't make it into the release tarball.
DOCS=( AUTHORS )

pkg_pretend() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp
}

pkg_setup() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp
}

src_configure() {
	# when using openmp and -O0 the testsuite fails
	# https://github.com/cschwan/sage-on-gentoo/issues/475
	# Still current as of 20200115
	use openmp && replace-flags -O0 -O1

	econf \
		$(use_enable debug) \
		$(use_enable openmp) \
		$(use_enable png) \
		$(use_enable cpu_flags_x86_sse2 sse2) \
		$(use_enable static-libs static)
}

src_install() {
	default
	find "${ED}" -name '*.la' -delete || die
}
