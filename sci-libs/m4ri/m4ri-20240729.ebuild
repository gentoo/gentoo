# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools flag-o-matic toolchain-funcs

DESCRIPTION="Method of four russian for inversion (M4RI)"
HOMEPAGE="https://github.com/malb/m4ri"
SRC_URI="https://github.com/malb/${PN}/archive/refs/tags/release-${PV}.tar.gz"

S="${WORKDIR}/${PN}-release-${PV}"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~ppc64 ~riscv ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos"
IUSE="debug openmp cpu_flags_x86_sse2 png"

BDEPEND="virtual/pkgconfig"
DEPEND="png? ( media-libs/libpng:= )"
RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}/${P}-pkgconfig.patch" )

# NEWS and ChangeLog are empty as of 2025-01-20.
DOCS=( AUTHORS README.md )

pkg_pretend() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp
}

pkg_setup() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp
}

src_prepare() {
	default
	eautoreconf
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
		$(use_enable cpu_flags_x86_sse2 sse2)
}

src_install() {
	default
	find "${ED}" -name '*.la' -delete || die
}
