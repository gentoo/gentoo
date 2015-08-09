# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4
inherit autotools eutils

DESCRIPTION="Audio sub system for multiple applications"
HOMEPAGE="http://www.directfb.org/"
SRC_URI="http://www.directfb.org/downloads/Core/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 hppa ppc x86"
IUSE="alsa cddb ffmpeg mad oss timidity vorbis"

RDEPEND=">=dev-libs/DirectFB-${PV}
	<dev-libs/DirectFB-1.6.3
	alsa? ( media-libs/alsa-lib )
	timidity? (
		media-libs/libtimidity
		media-sound/timidity++
		)
	vorbis? ( media-libs/libvorbis )
	mad? ( media-libs/libmad )
	cddb? ( media-libs/libcddb )
	ffmpeg? ( >=virtual/ffmpeg-9 )"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	sys-apps/sed"

src_prepare() {
	epatch \
		"${FILESDIR}"/${P}-gcc43.patch \
		"${FILESDIR}"/${P}-ffmpeg.patch \
		"${FILESDIR}"/${P}-ffmpeg-0.6.90.patch \
		"${FILESDIR}"/${P}-ffmpeg-0.10.patch \
		"${FILESDIR}"/${P}-libavformat54.patch \
		"${FILESDIR}"/${P}-libav-0.8.1.patch \
		"${FILESDIR}"/${P}-libav-9.patch \
		"${FILESDIR}"/${P}-ffmpeg2.patch \
		"${FILESDIR}"/${P}-segfault.patch

	sed -i -e 's:-O3 -ffast-math -pipe::' configure.in || die

	AT_M4DIR="m4" eautoreconf
}

src_configure() {
	local myaudio="wave"
	use alsa && myaudio+=" alsa"
	use oss && myaudio+=" oss"

	# Lite is used only for tests or examples.
	# Tremor isn't there with latest libvorbis.
	econf \
		--without-lite \
		--with-drivers="${myaudio}" \
		--without-examples \
		$(use_with timidity) \
		--with-wave \
		$(use_with vorbis) \
		--without-tremor \
		$(use_with mad) \
		$(use_with cddb cdda) \
		$(use_with ffmpeg) \
		--with-playlist
}

src_install() {
	emake DESTDIR="${D}" htmldir=/usr/share/doc/${PF}/html install
	dodoc AUTHORS ChangeLog NEWS README TODO
}
