# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=3

inherit base toolchain-funcs multilib

DESCRIPTION="C++ library implementing a real-time convolution matrix"
HOMEPAGE="http://kokkinizita.net/linuxaudio/downloads/index.html"
SRC_URI="http://kokkinizita.net/linuxaudio/downloads/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="sci-libs/fftw:3.0"
DEPEND="${RDEPEND}"

PATCHES=( "${FILESDIR}/${P}-makefile.patch" )

S=${WORKDIR}/${P}/libs

src_compile() {
	tc-export CXX
	emake || die
}

src_install() {
	emake PREFIX="${D}/usr" LIBDIR="$(get_libdir)" install || die
	dodoc "${WORKDIR}/${P}/AUTHORS" || die
}
