# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="JACK and ALSA Audio Analyser is an audio signal generator and spectrum analyser"
HOMEPAGE="http://kokkinizita.linuxaudio.org/linuxaudio/"
SRC_URI="http://kokkinizita.linuxaudio.org/linuxaudio/downloads/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"

RDEPEND="
	dev-libs/libclthreads
	>=media-libs/zita-alsa-pcmi-0.3
	sci-libs/fftw:3.0=
	virtual/jack
	x11-libs/gtk+:2
	x11-libs/libclxclient
"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${P}-Makefile.patch
)

src_compile() {
	tc-export CXX PKG_CONFIG
	emake -C source PREFIX="${EPREFIX}"/usr
}

src_install() {
	emake -C source PREFIX="${EPREFIX}"/usr DESTDIR="${D}" install
	einstalldocs
}
