# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/amsynth/amsynth-1.2.3-r1.ebuild,v 1.5 2014/08/10 21:03:44 slyfox Exp $

EAPI=4

inherit base autotools

MY_P=${P/ams/amS}
DESCRIPTION="Virtual analogue synthesizer"
HOMEPAGE="http://amsynthe.sourceforge.net/"
SRC_URI="mirror://sourceforge/amsynthe/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE="alsa debug jack oss sndfile"

RDEPEND="dev-cpp/gtkmm:2.4
	sndfile? ( >=media-libs/libsndfile-1 )
	alsa? ( media-libs/alsa-lib
		media-sound/alsa-utils )
	jack? ( media-sound/jack-audio-connection-kit )"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

S=${WORKDIR}/${MY_P}

PATCHES=( "${FILESDIR}/${P}-respect-cflags.patch" )

src_prepare() {
	base_src_prepare
	eautoreconf
}

src_configure() {
	econf \
		$(use_with oss) \
		$(use_with alsa) \
		$(use_with jack) \
		$(use_with sndfile) \
		$(use_enable debug)
}

src_install() {
	emake DESTDIR="${D}" install
	dodoc AUTHORS README
}

pkg_postinst() {
	elog
	elog "amSynth has been installed normally. If you would like to use"
	elog "the virtual keyboard option, then do:"
	elog "# emerge vkeybd"
	elog "and make sure you emerged amSynth with alsa support (USE=alsa)"
	elog
}
