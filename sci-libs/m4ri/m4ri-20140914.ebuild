# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit flag-o-matic toolchain-funcs

DESCRIPTION="Method of four russian for inversion (M4RI)"
HOMEPAGE="https://bitbucket.org/malb/m4ri"

# We use the SageMath tarball instead of the one from bitbucket because
# the bitbucket releases don't contain the "make dist" stuff and we
# would need autotools.eclass to generate it.
SRC_URI="http://files.sagemath.org/spkg/upstream/${PN}/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~ppc64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos"
IUSE="debug openmp cpu_flags_x86_sse2 png static-libs test"
RESTRICT="!test? ( test )"

BDEPEND="virtual/pkgconfig"
DEPEND="png? ( media-libs/libpng:= )"
RDEPEND="${DEPEND}"

# NEWS and ChangeLog are empty as of 2020-01-01, and README.md
# didn't make it into the release tarball.
DOCS=( AUTHORS )

pkg_pretend() {
	if use openmp ; then
		tc-has-openmp || die "Please switch to an openmp compatible compiler"
	fi
}

src_configure() {
	# when using openmp and -O0 the testsuite fails
	# https://github.com/cschwan/sage-on-gentoo/issues/475
	use openmp && replace-flags -O0 -O1

	# kiwifb: cachetune option is not available, because it kills (at
	# least my) X when I switch from yakuake to desktop
	econf \
		$(use_enable debug) \
		$(use_enable openmp) \
		$(use_enable png) \
		$(use_enable cpu_flags_x86_sse2 sse2) \
		$(use_enable static-libs static)
}

src_install(){
	default
	find "${ED}" -name '*.la' -delete || die
}
