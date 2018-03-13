# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit toolchain-funcs

DESCRIPTION="JACK and ALSA Audio Analyser is an audio signal generator and spectrum analyser"
HOMEPAGE="http://kokkinizita.linuxaudio.org/linuxaudio/"
SRC_URI="http://kokkinizita.linuxaudio.org/linuxaudio/downloads/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE=""

RDEPEND="media-libs/zita-alsa-pcmi
	media-sound/jack-audio-connection-kit
	>=media-libs/libclalsadrv-2.0.0
	>=media-libs/libclthreads-2.2.1
	>=media-libs/libclxclient-3.3.2
	sci-libs/fftw:3.0=
	x11-libs/gtk+:2"
DEPEND="${RDEPEND}"

PATCHES=( "${FILESDIR}"/${PN}-0.8.4-makefile.patch )

src_compile() {
	tc-export CC CXX
	emake -C source PREFIX="${EPREFIX}"/usr
}

src_install() {
	emake -C source PREFIX="${EPREFIX}"/usr DESTDIR="${D}" install
	einstalldocs
}
