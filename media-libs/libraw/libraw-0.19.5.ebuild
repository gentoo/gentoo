# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools multilib-minimal toolchain-funcs

MY_PN=LibRaw
MY_PV="${PV/_b/-B}"
MY_P="${MY_PN}-${MY_PV}"

DESCRIPTION="LibRaw is a library for reading RAW files obtained from digital photo cameras"
HOMEPAGE="https://www.libraw.org/ https://github.com/LibRaw/LibRaw"
SRC_URI="https://www.libraw.org/data/${MY_P}.tar.gz"

LICENSE="LGPL-2.1 CDDL"
SLOT="0/19" # subslot = libraw soname version
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86 ~amd64-linux ~x86-linux"
IUSE="examples jpeg +lcms openmp"

RDEPEND="jpeg? ( >=virtual/jpeg-0-r2:0[${MULTILIB_USEDEP}] )
	lcms? ( >=media-libs/lcms-2.5:2[${MULTILIB_USEDEP}] )"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

S="${WORKDIR}/${MY_P}"

DOCS=( Changelog.txt README.md )

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

multilib_src_configure() {
	local myeconfargs=(
		--disable-static
		--disable-jasper
		$(use_enable examples)
		$(use_enable jpeg)
		$(use_enable lcms)
		$(use_enable openmp)
	)
	ECONF_SOURCE="${S}" econf "${myeconfargs[@]}"
}

multilib_src_install_all() {
	einstalldocs

	# package installs .pc files
	find "${D}" -name '*.la' -delete || die
}
