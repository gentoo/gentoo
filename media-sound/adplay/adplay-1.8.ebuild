# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="A console player for AdLib music"
HOMEPAGE="https://adplug.github.io/"
SRC_URI="https://github.com/adplug/adplay-unix/releases/download/v${PV}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE="alsa ao oss sdl"

RDEPEND=">=media-libs/adplug-2.2.1
	dev-cpp/libbinio
	alsa? ( media-libs/alsa-lib )
	ao? ( media-libs/libao )
	sdl? ( media-libs/libsdl )"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_configure() {
	econf \
		--disable-output-esound \
		$(use_enable alsa output-alsa) \
		$(use_enable ao output-ao) \
		$(use_enable oss output-oss) \
		$(use_enable sdl output-sdl)
}
