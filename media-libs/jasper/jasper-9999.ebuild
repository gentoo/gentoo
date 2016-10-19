# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit autotools git-r3 multilib-minimal

DESCRIPTION="Implementation of the codec specified in the JPEG-2000 Part-1 standard"
HOMEPAGE="http://www.ece.uvic.ca/~mdadams/jasper/"
EGIT_REPO_URI="https://github.com/mdadams/jasper.git"

LICENSE="JasPer2.0"
SLOT="0/1"
KEYWORDS=""
IUSE="jpeg opengl static-libs"

RDEPEND="
	jpeg? ( >=virtual/jpeg-0-r2:0[${MULTILIB_USEDEP}] )
	opengl? (
		>=virtual/opengl-7.0-r1:0[${MULTILIB_USEDEP}]
		>=media-libs/freeglut-2.8.1:0[${MULTILIB_USEDEP}]
		virtual/glu
		)"
DEPEND="${RDEPEND}
	app-arch/unzip"

src_prepare() {
	default
	eautoreconf
}

multilib_src_configure() {
	ECONF_SOURCE="${S}" econf \
		$(use_enable jpeg libjpeg) \
		$(use_enable opengl) \
		$(use_enable static-libs static)
}

multilib_src_install_all() {
	einstalldocs
	dodoc -r doc/.

	# package provides .pc files
	find "${D}" -name '*.la' -delete || die
}
