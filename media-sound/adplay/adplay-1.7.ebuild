# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="A console player for AdLib music"
HOMEPAGE="http://adplug.sourceforge.net"
SRC_URI="mirror://sourceforge/adplug/${P}.tar.bz2"

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
PATCHES=( "${FILESDIR}/${PN}-1.7-fix-c++14.patch" )

src_configure() {
	econf \
		--disable-output-esound \
		$(use_enable alsa output-alsa) \
		$(use_enable ao output-ao) \
		$(use_enable oss output-oss) \
		$(use_enable sdl output-sdl)
}
