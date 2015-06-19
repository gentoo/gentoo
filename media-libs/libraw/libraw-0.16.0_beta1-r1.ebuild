# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/libraw/libraw-0.16.0_beta1-r1.ebuild,v 1.2 2014/06/18 19:47:54 mgorny Exp $

EAPI=5

inherit cmake-multilib toolchain-funcs

MY_PN=LibRaw
MY_PV=${PV/_b/-B}
MY_P=${MY_PN}-${MY_PV}

DESCRIPTION="LibRaw is a library for reading RAW files obtained from digital photo cameras"
HOMEPAGE="http://www.libraw.org/"
SRC_URI="http://www.libraw.org/data/${MY_P}.tar.gz
	demosaic? (
		http://www.libraw.org/data/LibRaw-demosaic-pack-GPL2-${MY_PV}.tar.gz
		http://www.libraw.org/data/LibRaw-demosaic-pack-GPL3-${MY_PV}.tar.gz
	)"

# Libraw also has it's own license, which is a pdf file and
# can be obtained from here:
# http://www.libraw.org/data/LICENSE.LibRaw.pdf
LICENSE="LGPL-2.1 CDDL GPL-2 GPL-3"
SLOT="0/10" # subslot = libraw soname version
KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~amd64-linux ~x86-linux"
IUSE="demosaic examples jpeg jpeg2k +lcms openmp"

RDEPEND="jpeg? ( >=virtual/jpeg-0-r2:0[${MULTILIB_USEDEP}] )
	jpeg2k? ( >=media-libs/jasper-1.900.1-r6[${MULTILIB_USEDEP}] )
	lcms? ( >=media-libs/lcms-2.5:2[${MULTILIB_USEDEP}] )"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

S=${WORKDIR}/${MY_P}

DOCS=( Changelog.txt README )

PATCHES=(
	"${FILESDIR}"/${PN}-0.16.0_alpha2-docs.patch
	"${FILESDIR}"/${PN}-0.16.0_alpha2-automagic-jasper.patch
	"${FILESDIR}"/${PN}-0.16.0_alpha2-libdir.patch
	"${FILESDIR}"/${PN}-0.16.0_alpha2-lcms2-first.patch
	"${FILESDIR}"/${PN}-0.16.0_alpha2-custom-demosaic-paths.patch
	"${FILESDIR}"/${PN}-0.16.0_beta1-libsuffix.patch
	"${FILESDIR}"/${PN}-0.16.0_beta1-libsuffixpc.patch
	"${FILESDIR}"/${PN}-0.16.0_beta1-include.patch
)

pkg_pretend() {
	if use openmp ; then
		tc-has-openmp || die "Please switch to an openmp compatible compiler"
	fi
}

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_enable openmp OPENMP)
		$(cmake-utils_use_enable jpeg JPEG)
		$(cmake-utils_use_enable jpeg2k JASPER)
		$(cmake-utils_use_enable lcms LCMS)
		$(cmake-utils_use_enable examples EXAMPLES)
		$(cmake-utils_use_enable demosaic DEMOSAIC_PACK_GPL2)
		$(cmake-utils_use_enable demosaic DEMOSAIC_PACK_GPL3)
		-DDEMOSAIC_PACK_GPL2_PATH="${WORKDIR}/${MY_PN}-demosaic-pack-GPL2-${MY_PV}"
		-DDEMOSAIC_PACK_GPL3_PATH="${WORKDIR}/${MY_PN}-demosaic-pack-GPL3-${MY_PV}"
	)
	cmake-multilib_src_configure
}
