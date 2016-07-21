# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils toolchain-funcs multilib

DESCRIPTION="Provides easy access to ALSA PCM devices"
HOMEPAGE="http://kokkinizita.linuxaudio.org/linuxaudio/"
SRC_URI="http://kokkinizita.linuxaudio.org/linuxaudio/downloads/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND="media-libs/alsa-lib"
RDEPEND="${DEPEND}"

src_prepare() {
	epatch "${FILESDIR}/makefile.patch"
}

src_compile() {
	tc-export CC CXX
	cd "${S}/libs"
	emake PREFIX="${EPREFIX}/usr" LIBDIR="$(get_libdir)"
	ln -s libzita-alsa-pcmi.so.0.2.0 libzita-alsa-pcmi.so
	cd "${S}/apps"
	emake PREFIX="${EPREFIX}/usr" LIBDIR="$(get_libdir)"
}

src_install() {
	cd "${S}/libs"
	emake PREFIX="${EPREFIX}/usr" LIBDIR="$(get_libdir)" DESTDIR="${D}" install
	cd "${S}/apps"
	emake PREFIX="${EPREFIX}/usr" LIBDIR="$(get_libdir)" DESTDIR="${D}" install
	cd "${S}"
	dodoc AUTHORS README
}
