# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit eutils multilib scons-utils toolchain-funcs

DESCRIPTION="A advanced Digital DJ tool based on Qt"
HOMEPAGE="http://www.mixxx.org/"
SRC_URI="http://downloads.${PN}.org/${P}/${P}-src.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="aac debug doc hid mp3 mp4 qt4 +qt5 shout wavpack ffmpeg"
REQUIRED_USE="^^ ( qt4 qt5 )"

# fails to compile system-fidlib. Add ">media-libs/fidlib-0.9.10-r1" once this
# got fixed
RDEPEND="dev-db/sqlite
	dev-libs/libusb:1
	dev-libs/protobuf
	media-libs/chromaprint
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
	virtual/opengl
	x11-libs/libX11
	aac? (
		media-libs/faad2
		media-libs/libmp4v2:0
	)
	hid? ( dev-libs/hidapi )
	mp3? ( media-libs/libmad )
	mp4? ( media-libs/libmp4v2:= )
	qt4? (
		dev-qt/qtcore:4
		dev-qt/qtgui:4
		dev-qt/qtopengl:4
		dev-qt/qtscript:4
		dev-qt/qtsql:4
		dev-qt/qtsvg:4
	)
	qt5? (
		dev-qt/qtconcurrent:5
		dev-qt/qtcore:5
		dev-qt/qtgui:5
		dev-qt/qtnetwork:5
		dev-qt/qtopengl:5
		dev-qt/qtscript:5[scripttools]
		dev-qt/qtsql:5
		dev-qt/qtsvg:5
		dev-qt/qtwidgets:5
		dev-qt/qtxml:5
	)
	shout? ( media-libs/libshout )
	wavpack? ( media-sound/wavpack )
	ffmpeg? ( media-video/ffmpeg )"
# media-libs/rubberband RDEPENDs on sci-libs/fftw:3.0
DEPEND="${RDEPEND}
	sci-libs/fftw:3.0
	virtual/pkgconfig
	qt5? (
		dev-qt/qttest:5
		dev-qt/qtxmlpatterns:5
	)"

PATCHES=(
	"${FILESDIR}"/${PN}-2.0.0-docs.patch
	#"${FILESDIR}"/${PN}-2.0.0-system-libs.patch
)

src_prepare() {
	# use multilib compatible directory for plugins
	sed -i -e "/unix_lib_path =/s/'lib'/'$(get_libdir)'/" src/SConscript || die

	default
}

src_configure() {
	local myqtdir=qt5
	if use qt4 ; then
		myqtdir="qt4"
	fi

	myesconsargs=(
		prefix="${EPREFIX}/usr"
		qtdir="${EPREFIX}/usr/$(get_libdir)/${myqtdir}"
		faad="$(usex aac 1 0)"
		ffmpeg="$(usex ffmpeg 1 0)"
		hid="$(usex hid 1 0)"
		hifieq=1
		m4a="$(usex mp4 1 0)"
		mad="$(usex mp3 1 0)"
		optimize=native
		qdebug="$(usex debug 1 0)"
		qt5="$(usex qt5 1 0)"
		shoutcast="$(usex shout 1 0)"
		vinylcontrol=1
		wv="$(usex wavpack 1 0)"
	)
}

src_compile() {
	CC="$(tc-getCC)" CXX="$(tc-getCXX)" LINKFLAGS="${LDFLAGS}" \
	LIBDIR="${EPREFIX}/usr/$(get_libdir)" escons ${myesconsargs[@]}
}

src_install() {
	CC="$(tc-getCC)" CXX="$(tc-getCXX)" LINKFLAGS="${LDFLAGS}" \
	LIBDIR="${EPREFIX}/usr/$(get_libdir)" escons ${myesconsargs[@]} \
		install_root="${ED}"/usr install

	dodoc README Mixxx-Manual.pdf
}
