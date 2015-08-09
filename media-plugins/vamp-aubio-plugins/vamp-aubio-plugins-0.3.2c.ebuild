# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit flag-o-matic toolchain-funcs multilib

DESCRIPTION="Onset detection, pitch tracking, note tracking and tempo tracking plugins"
HOMEPAGE="http://www.vamp-plugins.org/"
SRC_URI="mirror://sourceforge/vamp/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc ppc64 x86"
IUSE=""

DEPEND=">=media-libs/aubio-0.3.2
	media-libs/vamp-plugin-sdk
	=sci-libs/fftw-3*"
RDEPEND="${DEPEND}"

src_compile() {
	tc-export CXX
	# It only builds a shared library for a plugin
	# So we force PIC
	append-flags -fPIC -DPIC
	# Use shared libs
	sed -i -e "s/ -Wl,-Bstatic//" Makefile
	emake || die "emake failed"
}

src_install() {
	insinto /usr/$(get_libdir)/vamp
	doins vamp-aubio.so vamp-aubio.cat
	dodoc README
}
