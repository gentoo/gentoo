# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/mixxx/mixxx-1.10.1.ebuild,v 1.4 2013/03/02 21:57:27 hwoarang Exp $

EAPI=4

inherit eutils multilib scons-utils toolchain-funcs

DESCRIPTION="A Qt based Digital DJ tool"
HOMEPAGE="http://mixxx.sourceforge.net"
SRC_URI="http://downloads.mixxx.org/${P}/${P}-src.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="aac debug doc mp3 pulseaudio shout wavpack"

RDEPEND="media-libs/fidlib
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
	dev-qt/qtgui:4
	dev-qt/qtopengl:4
	dev-qt/qtsql:4
	dev-qt/qtsvg:4
	dev-qt/qtwebkit:4
	dev-qt/qtxmlpatterns:4
	aac? (
		media-libs/faad2
		media-libs/libmp4v2:0
	)
	mp3? ( media-libs/libmad )
	pulseaudio? ( media-sound/pulseaudio )
	shout? ( media-libs/libshout )
	wavpack? ( media-sound/wavpack )"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-1.10.0-system-libs.patch
	epatch "${FILESDIR}"/${PN}-1.10.0-cflags.patch
	epatch "${FILESDIR}"/${PN}-1.10.0-docs.patch
	epatch "${FILESDIR}"/${PN}-1.10.0-no-bzr.patch

	# use multilib compatible directory for plugins
	sed -i -e "/unix_lib_path =/s/'lib'/'$(get_libdir)'/" src/SConscript || die

	# alter startup command when pulseaudio support is disabled
	if ! use pulseaudio ; then
		sed -i -e 's:pasuspender ::' src/mixxx.desktop || die
	fi
}

src_compile() {
	CC="$(tc-getCC)" CXX="$(tc-getCXX)" LINKFLAGS="${LDFLAGS}" \
	LIBPATH="/usr/$(get_libdir)" escons \
		prefix=/usr \
		qtdir=/usr/$(get_libdir)/qt4 \
		hifieq=1 \
		vinylcontrol=1 \
		optimize=0 \
		$(use_scons aac faad) \
		$(use_scons debug qdebug) \
		$(use_scons mp3 mad) \
		$(use_scons shout shoutcast) \
		$(use_scons wavpack wv)
}

src_install() {
	CC="$(tc-getCC)" CXX="$(tc-getCXX)" LINKFLAGS="${LDFLAGS}" \
	LIBPATH="/usr/$(get_libdir)" escons install \
		prefix=/usr \
		qtdir=/usr/$(get_libdir)/qt4 \
		install_root="${D}"/usr

	dodoc README Mixxx-Manual.pdf
}
