# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit toolchain-funcs prefix

MY_P="munt_${PV//./_}"
DESCRIPTION="ALSA MIDI driver for emulating the Roland MT-32, CM-32L, CM-64 and LAPC-I"
HOMEPAGE="https://github.com/munt/munt"
SRC_URI="https://github.com/munt/munt/archive/${MY_P}.tar.gz"
LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="X"

DEPEND="media-libs/alsa-lib
	media-libs/munt-mt32emu
	X? (
		x11-libs/libX11
		x11-libs/libXpm
		x11-libs/libXt
	)"

RDEPEND="${DEPEND}"

S="${WORKDIR}/munt-${MY_P}/mt32emu_alsadrv"
DATA="/usr/share/mt32-rom-data"

src_prepare() {
	default

	# Fix MT32 ROM path.
	hprefixify src/alsadrv.cpp
}

src_compile() {
	emake mt32d CXX="$(tc-getCXX)" CXXFLAGS="${CXXFLAGS} ${LDFLAGS}"
	use X && emake xmt32 CXX="$(tc-getCXX)" CXXFLAGS="${CXXFLAGS} ${LDFLAGS}"
}

src_install() {
	dobin mt32d
	use X && dobin xmt32
	dodoc {AUTHORS,README}.txt
	keepdir "${DATA}"
}

pkg_postinst() {
	einfo "MT32_CONTROL.ROM and MT32_PCM.ROM cannot be legally included so you must"
	einfo "obtain them and place them in ${EPREFIX}${DATA}."
}
