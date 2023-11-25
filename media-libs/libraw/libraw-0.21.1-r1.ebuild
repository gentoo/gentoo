# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit multilib-minimal toolchain-funcs

MY_PN=LibRaw
MY_PV="${PV/_b/-B}"
MY_P="${MY_PN}-${MY_PV}"

DESCRIPTION="LibRaw is a library for reading RAW files obtained from digital photo cameras"
HOMEPAGE="https://www.libraw.org/ https://github.com/LibRaw/LibRaw"
SRC_URI="https://www.libraw.org/data/${MY_P}.tar.gz"

LICENSE="LGPL-2.1 CDDL"
# SONAME isn't exactly the same as PV but it does correspond and
# libraw has unstable ABI across releases.
SLOT="0/$(ver_cut 1-2)"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv sparc x86 ~amd64-linux ~x86-linux"
IUSE="examples jpeg +lcms openmp zlib"

RDEPEND="
	jpeg? ( media-libs/libjpeg-turbo:=[${MULTILIB_USEDEP}] )
	lcms? ( >=media-libs/lcms-2.5:2[${MULTILIB_USEDEP}] )
	zlib? ( sys-libs/zlib[${MULTILIB_USEDEP}] )
"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

S="${WORKDIR}/${MY_P}"

DOCS=( Changelog.txt README.md )

PATCHES=( "${FILESDIR}/${P}-CVE-2023-1729.patch" )

pkg_pretend() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp
}

pkg_setup() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp
}

multilib_src_configure() {
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
