# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

GIT_COMMITID="ed8105083ab72f9afac9d18b7563fbc3d6c1c925"
MY_PV="${PV}-${GIT_COMMITID}"
MY_P="${PN}-${MY_PV}"

inherit flag-o-matic toolchain-funcs

DESCRIPTION="ALSA Volume Control Attenuation Measurement Tool"
HOMEPAGE="http://pulseaudio.org/wiki/BadDecibel"
SRC_URI="http://git.0pointer.de/?p=${PN}.git;a=snapshot;h=${GIT_COMMITID};sf=tgz -> ${MY_P}.tar.gz"

LICENSE="BSD" # need to confirm w/ upstream
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND=">=media-libs/alsa-lib-1.0.26"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

S="${WORKDIR}/${PN}"

PATCHES=( "${FILESDIR}"/${P}-makefile.patch )

src_configure() {
	tc-export CC PKG_CONFIG
	strip-flags
}

src_install() {
	dobin db{measure,verify}
	dodoc README
}
