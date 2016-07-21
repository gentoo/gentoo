# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils flag-o-matic multilib toolchain-funcs

DESCRIPTION="C++ library implementing a real-time convolution matrix"
HOMEPAGE="http://kokkinizita.linuxaudio.org/linuxaudio/downloads/index.html"
SRC_URI="http://kokkinizita.linuxaudio.org/linuxaudio/downloads/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="cpu_flags_x86_sse"

RDEPEND="sci-libs/fftw:3.0="
DEPEND="${RDEPEND}"

S=${WORKDIR}/${P}/libs

src_prepare() {
	epatch "${FILESDIR}"/${P}-makefile.patch
}

src_compile() {
	# upstream defaults to this on x86 but patched out of the Makefile
	# try to reenable optimisation for x86 and allow building on other arch's
	use cpu_flags_x86_sse && append-flags "-msse" "-mfpmath=sse"

	emake CXX="$(tc-getCXX)"
}

src_install() {
	emake DESTDIR="${D}" PREFIX="${EPREFIX}/usr" LIBDIR="$(get_libdir)" install
	dodoc "${WORKDIR}/${P}/AUTHORS" "${WORKDIR}/${P}/README"
}
