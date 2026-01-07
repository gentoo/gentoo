# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit flag-o-matic libtool multilib-minimal toolchain-funcs

MY_PN=LibRaw
MY_PV="${PV/_b/-B}"
MY_P="${MY_PN}-${MY_PV}"

DESCRIPTION="LibRaw is a library for reading RAW files obtained from digital photo cameras"
HOMEPAGE="https://www.libraw.org/ https://github.com/LibRaw/LibRaw"
SRC_URI="https://www.libraw.org/data/${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="LGPL-2.1 CDDL"
# SONAME isn't exactly the same as PV but it does correspond and
# libraw has unstable ABI across releases.
SLOT="0/$(ver_cut 1-2)"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~sparc ~x86"
IUSE="examples hardened jpeg +lcms openmp zlib"

RDEPEND="
	jpeg? ( media-libs/libjpeg-turbo:=[${MULTILIB_USEDEP}] )
	lcms? ( >=media-libs/lcms-2.5:2[${MULTILIB_USEDEP}] )
	zlib? ( virtual/zlib:=[${MULTILIB_USEDEP}] )
"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

DOCS=( Changelog.txt README.md )

pkg_pretend() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp
}

pkg_setup() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp
}

src_prepare() {
	default
	elibtoolize

	if tc-is-clang && use openmp ; then
		append-libs omp
	fi
}

multilib_src_configure() {
	# added in 0.21.3 if selected calloc() will be used to prevent uninitialized heap data leak
	use hardened && append-cppflags "-DLIBRAW_CALLOC_RAWSTORE"

	local myeconfargs=(
		--disable-jasper
		$(multilib_native_use_enable examples)
		$(use_enable jpeg)
		$(use_enable lcms)
		$(use_enable openmp)
		$(use_enable zlib)
	)
	ECONF_SOURCE="${S}" econf "${myeconfargs[@]}"
}

multilib_src_install_all() {
	einstalldocs

	# package installs .pc files
	find "${D}" -name '*.la' -delete || die
}
