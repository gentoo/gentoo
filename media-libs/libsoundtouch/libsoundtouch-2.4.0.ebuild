# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools flag-o-matic multilib-minimal toolchain-funcs

MY_PN=${PN/lib}
MY_P=${MY_PN}-${PV}
DESCRIPTION="Audio processing library for changing tempo, pitch and playback rates"
HOMEPAGE="https://www.surina.net/soundtouch/ https://codeberg.org/soundtouch/soundtouch"
SRC_URI="https://www.surina.net/${MY_PN}/${MY_P}.tar.gz"
S="${WORKDIR}/${MY_PN}"

LICENSE="LGPL-2.1"
SLOT="0/1" # subslot is libSoundTouch.so soname
KEYWORDS="amd64 ~arm ~arm64 ~hppa ~loong ~mips ppc ppc64 ~riscv x86"
IUSE="openmp static-libs"
IUSE+=" cpu_flags_arm_neon cpu_flags_x86_sse"

BDEPEND="virtual/pkgconfig"

pkg_pretend() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp
}

pkg_setup() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp
}

src_prepare() {
	default
	sed -i "s:^\(dist_doc_DATA=\)COPYING.TXT :\1:" Makefile.am || die

	tc-is-clang && use openmp && append-libs omp

	eautoreconf
}

multilib_src_configure() {
	local myeconfargs=(
		--enable-shared
		$(use_enable cpu_flags_arm_neon neon-optimizations)
		$(use_enable cpu_flags_x86_sse x86-optimizations)
		$(use_enable openmp)
		$(use_enable static-libs static)
	)
	ECONF_SOURCE="${S}" econf "${myeconfargs[@]}"
}

multilib_src_compile() {
	emake CFLAGS="${CFLAGS}" CXXFLAGS="${CXXFLAGS}"
}

multilib_src_install() {
	emake DESTDIR="${D}" pkgdocdir="${EPREFIX}"/usr/share/doc/${PF}/html install
}

multilib_src_install_all() {
	find "${ED}" -type f -name '*.la' -delete || die
}
