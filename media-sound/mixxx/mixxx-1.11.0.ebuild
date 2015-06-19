# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/mixxx/mixxx-1.11.0.ebuild,v 1.1 2014/12/11 04:21:00 radhermit Exp $

EAPI=5

inherit eutils multilib scons-utils toolchain-funcs

DESCRIPTION="A Qt based Digital DJ tool"
HOMEPAGE="http://mixxx.sourceforge.net"
SRC_URI="http://downloads.mixxx.org/${P}/${P}-src.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="aac debug doc hid mp3 mp4 pulseaudio shout vamp wavpack"

RDEPEND="
	dev-libs/protobuf:=
	dev-libs/libusb:1
	>=media-libs/fidlib-0.9.10-r1
	media-libs/flac
	media-libs/libid3tag
	media-libs/libogg
	media-libs/libsndfile
	>=media-libs/libsoundtouch-1.5
	media-libs/libvorbis
	>=media-libs/portaudio-19_pre
	media-libs/portmidi
	media-libs/taglib
	virtual/glu
	virtual/opengl
	dev-qt/qtcore:4
	dev-qt/qtgui:4
	dev-qt/qtopengl:4
	dev-qt/qtscript:4
	dev-qt/qtsql:4
	aac? (
		media-libs/faad2
		media-libs/libmp4v2:0
	)
	hid? ( dev-libs/hidapi )
	mp3? ( media-libs/libmad )
	mp4? ( media-libs/libmp4v2 )
	pulseaudio? ( media-sound/pulseaudio )
	shout? ( media-libs/libshout )
	wavpack? ( media-sound/wavpack )
	vamp? ( media-libs/vamp-plugin-sdk )
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-1.10.0-cflags.patch
	epatch "${FILESDIR}"/${P}-system-libs.patch
	EPATCH_OPTS="-l" epatch "${FILESDIR}"/${PN}-1.10.0-docs.patch
	epatch "${FILESDIR}"/${P}-no-bzr.patch

	# use multilib compatible directory for plugins
	sed -i "/unix_lib_path =/s/'lib'/'$(get_libdir)'/" src/SConscript || die

	# alter startup command when pulseaudio support is disabled
	if ! use pulseaudio ; then
		sed -i 's:pasuspender ::' src/mixxx.desktop || die
	fi
}

src_configure() {
	myesconsargs=(
		prefix="${EPREFIX}/usr"
		qtdir="${EPREFIX}/usr/$(get_libdir)/qt4"
		hifieq=1
		vinylcontrol=1
		optimize=0
		$(use_scons aac faad)
		$(use_scons debug qdebug)
		$(use_scons hid hid)
		$(use_scons mp3 mad)
		$(use_scons mp4 m4a)
		$(use_scons shout shoutcast)
		$(use_scons wavpack wv)
		$(use_scons vamp)
	)
}

src_compile() {
	CC="$(tc-getCC)" CXX="$(tc-getCXX)" LINKFLAGS="${LDFLAGS}" \
		LIBPATH="${EPREFIX}/usr/$(get_libdir)" escons
}

src_install() {
	CC="$(tc-getCC)" CXX="$(tc-getCXX)" LINKFLAGS="${LDFLAGS}" \
	LIBPATH="${EPREFIX}/usr/$(get_libdir)" escons \
		install_root="${ED}"/usr install

	dodoc README Mixxx-Manual.pdf
}
