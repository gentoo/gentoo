# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit flag-o-matic toolchain-funcs multilib

DESCRIPTION="Onset detection, pitch tracking, note tracking and tempo tracking plugins"
HOMEPAGE="http://www.vamp-plugins.org/"
SRC_URI="http://aubio.org/pub/vamp-aubio-plugins/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc ppc64 x86"
IUSE=""

DEPEND=">=media-libs/aubio-0.4.1
	media-libs/vamp-plugin-sdk
	=sci-libs/fftw-3*"
RDEPEND="${DEPEND}"

src_compile() {
	tc-export CXX
	emake CFLAGS="${CFLAGS} -fPIC" -f Makefile.linux
}

src_install() {
	insinto /usr/$(get_libdir)/vamp
	doins vamp-aubio.so vamp-aubio.cat
	dodoc README.md
}
