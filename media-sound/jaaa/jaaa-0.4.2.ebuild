# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/jaaa/jaaa-0.4.2.ebuild,v 1.4 2011/03/28 15:34:09 ssuominen Exp $

EAPI=2
inherit eutils toolchain-funcs

DESCRIPTION="The JACK and ALSA Audio Analyser is an audio signal generator and spectrum analyser"
HOMEPAGE="http://www.kokkinizita.net/linuxaudio"
SRC_URI="http://www.kokkinizita.net/linuxaudio/downloads/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc ~sparc x86"
IUSE=""

RDEPEND="media-sound/jack-audio-connection-kit
	>=media-libs/libclalsadrv-1.2.1
	>=media-libs/libclthreads-2.2.1
	>=media-libs/libclxclient-3.3.2
	>=sci-libs/fftw-3.0.0
	x11-libs/gtk+:2"
DEPEND="${RDEPEND}"

S=${WORKDIR}/${PN}

src_prepare() {
	epatch "${FILESDIR}"/${P}-makefile.patch
}

src_compile() {
	tc-export CC CXX
	emake || die
}

src_install() {
	dobin jaaa || die
	dodoc AUTHORS README
}
