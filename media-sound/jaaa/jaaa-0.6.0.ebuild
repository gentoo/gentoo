# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/jaaa/jaaa-0.6.0.ebuild,v 1.3 2014/01/25 19:21:32 radhermit Exp $

EAPI=5
inherit eutils toolchain-funcs

DESCRIPTION="The JACK and ALSA Audio Analyser is an audio signal generator and spectrum analyser"
HOMEPAGE="http://kokkinizita.linuxaudio.org/linuxaudio/"
SRC_URI="http://kokkinizita.linuxaudio.org/linuxaudio/downloads/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"
IUSE=""

RDEPEND="media-sound/jack-audio-connection-kit
	>=media-libs/libclalsadrv-2.0.0
	>=media-libs/libclthreads-2.2.1
	>=media-libs/libclxclient-3.3.2
	>=sci-libs/fftw-3.0.0
	x11-libs/gtk+:2"
DEPEND="${RDEPEND}"

src_prepare() {
	epatch "${FILESDIR}"/${P}-makefile.patch
}

src_compile() {
	tc-export CC CXX
	emake PREFIX=/usr
}

src_install() {
	emake DESTDIR="${D}" PREFIX=/usr install
	dodoc AUTHORS README
}
