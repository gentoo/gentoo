# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils multilib scons-utils toolchain-funcs

DESCRIPTION="A advanced Digital DJ tool based on Qt"
HOMEPAGE="http://www.mixxx.org/"
SRC_URI="http://downloads.${PN}.org/${P}/${P}-src.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="aac debug hid mp3 mp4 shout wavpack ffmpeg"

RDEPEND="dev-libs/protobuf
	media-libs/chromaprint
	>=media-libs/fidlib-0.9.10-r1
	media-libs/flac
	media-libs/libid3tag
	media-libs/libogg
	media-libs/libsndfile
	>=media-libs/libsoundtouch-1.5
	media-libs/libvorbis
	>=media-libs/portaudio-19_pre
	media-libs/portmidi
	media-libs/rubberband
	media-libs/taglib
	media-libs/vamp-plugin-sdk
	sci-libs/fftw:3.0
	dev-qt/qtgui:4
	dev-qt/qtopengl:4
	dev-qt/qtsql:4
	dev-qt/qtsvg:4
	dev-qt/qtxmlpatterns:4
	aac? (
		media-libs/faad2
		media-libs/libmp4v2:0
	)
	hid? ( dev-libs/hidapi )
	mp3? ( media-libs/libmad )
	mp4? ( media-libs/libmp4v2:= )
	pulseaudio? ( media-sound/pulseaudio )
	shout? ( media-libs/libshout )
	wavpack? ( media-sound/wavpack )
	ffmpeg? ( <media-video/ffmpeg-3.0 )"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_prepare() {
	epatch "${FILESDIR}"/${P}-docs.patch
}

src_configure() {
	myesconsargs=(
		prefix="${EPREFIX}/usr"
		qtdir="${EPREFIX}/usr/$(get_libdir)/qt4"
		vinylcontrol=1
		optimize=native
		$(use_scons aac faad)
		$(use_scons debug qdebug)
		$(use_scons hid hid)
		$(use_scons mp3 mad)
		$(use_scons mp4 m4a)
		$(use_scons shout shoutcast)
		$(use_scons wavpack wv)
		$(use_scons ffmpeg ffmpeg)
	)
}

src_compile() {
	CC="$(tc-getCC)" CXX="$(tc-getCXX)" LINKFLAGS="${LDFLAGS}" \
	LIBDIR="${EPREFIX}/usr/$(get_libdir)" escons
}

src_install() {
	CC="$(tc-getCC)" CXX="$(tc-getCXX)" LINKFLAGS="${LDFLAGS}" \
	LIBDIR="${EPREFIX}/usr/$(get_libdir)" escons \
		install_root="${ED}"/usr install

	dodoc README Mixxx-Manual.pdf
}
