# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/libclthreads/libclthreads-2.4.0-r1.ebuild,v 1.1 2015/03/18 11:48:09 aballier Exp $

EAPI=5

inherit eutils multilib toolchain-funcs

MY_P="${P/lib/}"

S="${WORKDIR}/${MY_P}"

DESCRIPTION="An audio library by Fons Adriaensen <fons.adriaensen@skynet.be>"
HOMEPAGE="http://kokkinizita.linuxaudio.org/linuxaudio/index.html"
SRC_URI="http://kokkinizita.linuxaudio.org/linuxaudio/downloads/${MY_P}.tar.bz2"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"
IUSE=""

src_prepare() {
	epatch "${FILESDIR}/${PN}-2.4.0-Makefile.patch"
}

src_compile() {
	tc-export CC CXX
	emake
}

src_install() {
	emake CLTHREADS_LIBDIR="/usr/$(get_libdir)" DESTDIR="${ED}" install || die "make install failed"
	dodoc AUTHORS
}
