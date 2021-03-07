# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools linux-info

DESCRIPTION="Soundcard Oscilloscope for X"
HOMEPAGE="http://xoscope.sourceforge.net"
SRC_URI="mirror://sourceforge/project/${PN}/${PN}/${PV}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"

RDEPEND="
	sci-libs/fftw:3.0=
	virtual/man
	x11-libs/gtkdatabox"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

CONFIG_CHECK="~!SND_PCM_OSS"
ERROR_SND_PCM_OSS="CONFIG_SND_PCM_OSS is needed to support sound card input via /dev/dsp"

PATCHES=(
	"${FILESDIR}"/${P}-man_no_-Tutf8.patch
	"${FILESDIR}"/${P}-fno-common.patch
)

src_prepare() {
	default
	eautoreconf
}
