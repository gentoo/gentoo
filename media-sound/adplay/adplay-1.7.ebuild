# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/adplay/adplay-1.7.ebuild,v 1.6 2012/05/05 08:05:54 mgorny Exp $

EAPI=4

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

DOCS=( AUTHORS ChangeLog NEWS README TODO )

src_configure() {
	econf \
		$(use_enable alsa output-alsa) \
		$(use_enable ao output-ao) \
		--disable-output-esound \
		$(use_enable oss output-oss) \
		$(use_enable sdl output-sdl)
}
