# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit autotools-multilib toolchain-funcs

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
SLOT="0/15" # subslot = libraw soname version
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86 ~amd64-linux ~x86-linux"
IUSE="demosaic examples jpeg jpeg2k +lcms openmp"

RDEPEND="jpeg? ( >=virtual/jpeg-0-r2:0[${MULTILIB_USEDEP}] )
	jpeg2k? ( >=media-libs/jasper-1.900.1-r6[${MULTILIB_USEDEP}] )
	lcms? ( >=media-libs/lcms-2.5:2[${MULTILIB_USEDEP}] )"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

S=${WORKDIR}/${MY_P}

DOCS=( Changelog.txt README )

pkg_pretend() {
	if use openmp ; then
		tc-has-openmp || die "Please switch to an openmp compatible compiler"
	fi
}

src_configure() {
	local myeconfargs=(
		$(use_enable demosaic demosaic-pack-gpl2)
		$(use_enable demosaic demosaic-pack-gpl3)
		$(use_enable examples)
		$(use_enable jpeg)
		$(use_enable jpeg2k jasper)
		$(use_enable lcms)
		$(use_enable openmp)
	)
	autotools-multilib_src_configure
}
