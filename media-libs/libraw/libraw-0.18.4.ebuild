# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit multilib-minimal toolchain-funcs

MY_PN=LibRaw
MY_PV=${PV/_b/-B}
MY_P=${MY_PN}-${MY_PV}

DESCRIPTION="LibRaw is a library for reading RAW files obtained from digital photo cameras"
HOMEPAGE="https://www.libraw.org/ https://github.com/LibRaw/LibRaw"
SRC_URI="https://www.libraw.org/data/${MY_P}.tar.gz
	demosaic? (
		https://www.libraw.org/data/LibRaw-demosaic-pack-GPL2-${MY_PV}.tar.gz
		https://www.libraw.org/data/LibRaw-demosaic-pack-GPL3-${MY_PV}.tar.gz
	)"

LICENSE="LGPL-2.1 CDDL demosaic? ( GPL-2 GPL-3 )"
SLOT="0/16" # subslot = libraw soname version
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 sparc x86 ~amd64-linux ~x86-linux"
IUSE="demosaic examples jpeg jpeg2k +lcms openmp"

RDEPEND="jpeg? ( >=virtual/jpeg-0-r2:0[${MULTILIB_USEDEP}] )
	jpeg2k? ( >=media-libs/jasper-1.900.1-r6:=[${MULTILIB_USEDEP}] )
	lcms? ( >=media-libs/lcms-2.5:2[${MULTILIB_USEDEP}] )"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

S=${WORKDIR}/${MY_P}

DOCS=( Changelog.txt README )

PATCHES=(
	"${FILESDIR}"/${PN}-0.18.4-glibc-2.27.patch
)

pkg_pretend() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp
}

pkg_setup() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp
}

multilib_src_configure() {
	local myeconfargs=(
		--disable-static
		$(use_enable demosaic demosaic-pack-gpl2)
		$(use_enable demosaic demosaic-pack-gpl3)
		$(use_enable examples)
		$(use_enable jpeg)
		$(use_enable jpeg2k jasper)
		$(use_enable lcms)
		$(use_enable openmp)
	)
	ECONF_SOURCE="${S}" \
	econf "${myeconfargs[@]}"
}

multilib_src_install_all() {
	einstalldocs

	# package installs .pc files
	find "${D}" -name '*.la' -delete || die
}
