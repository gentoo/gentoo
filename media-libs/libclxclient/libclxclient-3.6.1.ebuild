# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/libclxclient/libclxclient-3.6.1.ebuild,v 1.3 2015/03/18 10:06:21 aballier Exp $

inherit eutils multilib toolchain-funcs

MY_P=${P/lib/}

S="${WORKDIR}/${MY_P}"

DESCRIPTION="An audio library by Fons Adriaensen <fons.adriaensen@skynet.be>"
HOMEPAGE="http://kokkinizita.linuxaudio.org/linuxaudio/index.html"
SRC_URI="http://kokkinizita.linuxaudio.org/linuxaudio/downloads/${MY_P}.tar.bz2"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"
IUSE=""

RDEPEND="x11-libs/libX11
	x11-libs/libXft
	>=media-libs/freetype-2
	>=media-libs/libclthreads-2.4.0"
DEPEND="${RDEPEND}"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}/${P}-Makefile.patch"
}

src_compile() {
	tc-export CC CXX
	emake PREFIX="/usr" LIBDIR="$(get_libdir)" || die "emake failed"
}

src_install() {
	emake PREFIX="/usr" LIBDIR="$(get_libdir)" DESTDIR="${D}" install || die "make install failed"
	dodoc AUTHORS
}
