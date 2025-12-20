# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools multilib-minimal toolchain-funcs flag-o-matic

DESCRIPTION="C library providing BLAKE2b, BLAKE2s, BLAKE2bp, BLAKE2sp"
HOMEPAGE="https://github.com/BLAKE2/libb2"
GITHASH="73d41c8255a991ed2adea41c108b388d9d14b449"
SRC_URI="https://github.com/BLAKE2/libb2/archive/${GITHASH}.tar.gz -> ${P}.tar.gz"

LICENSE="CC0-1.0"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~arm64-macos ~x64-macos ~x64-solaris"
IUSE="static-libs native-cflags openmp"

DEPEND="
	openmp? (
		|| ( >=sys-devel/gcc-4.2:*[openmp] llvm-runtimes/clang-runtime:*[openmp] )
	)
"
RDEPEND="${DEPEND}"

S=${WORKDIR}/${PN}-${GITHASH}

PATCHES=( "${FILESDIR}"/${P}-distcc.patch )

pkg_pretend() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp
}

pkg_setup() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp
}

src_prepare() {
	default
	# fix bashism
	sed -i -e 's/ == / = /' configure.ac || die
	# https://github.com/BLAKE2/libb2/pull/28
	echo 'libb2_la_LDFLAGS = -no-undefined' >> src/Makefile.am || die
	# make memset_s available
	[[ ${CHOST} == *-solaris* ]] && append-cppflags -D__STDC_WANT_LIB_EXT1__=1
	eautoreconf  # upstream doesn't make releases
}

multilib_src_configure() {
	ECONF_SOURCE=${S} \
	econf \
		$(use_enable static-libs static) \
		$(use_enable native-cflags native) \
		$(use_enable openmp)
}

do_make() {
	# respect our CFLAGS when native-cflags is not in effect
	local openmp=$(use openmp && echo -fopenmp)
	emake $(use native-cflags && echo no)CFLAGS="${CFLAGS} ${openmp}" "$@"
}

multilib_src_compile() {
	do_make
}

multilib_src_test() {
	do_make check
}

multilib_src_install_all() {
	einstalldocs
	find "${ED}" -name '*.la' -type f -delete || die
}
