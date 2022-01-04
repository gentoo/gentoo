# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake xdg udev prefix

DESCRIPTION="Advanced Digital DJ tool based on Qt"
HOMEPAGE="https://www.mixxx.org/"

SRC_URI="https://github.com/mixxxdj/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz
	doc? ( https://downloads.mixxx.org/manual/2.3/mixxx-manual-2.3-en.pdf ->
			${P}-Manual.pdf )"
KEYWORDS="~amd64 ~arm64 ~x86"

LICENSE="GPL-2"
SLOT="0"
IUSE="aac doc ffmpeg hid keyfinder lv2 mp3 mp4 opus qtkeychain shout wavpack"

RDEPEND="
	dev-db/sqlite
	dev-libs/glib:2
	dev-libs/protobuf:0=
	dev-qt/qtconcurrent:5
	dev-qt/qtcore:5
	dev-qt/qtdbus:5
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5
	dev-qt/qtopengl:5
	dev-qt/qtscript:5[scripttools]
	dev-qt/qtsql:5
	dev-qt/qtsvg:5
	dev-qt/qtwidgets:5
	dev-qt/qtx11extras:5
	dev-qt/qtxml:5
	media-libs/chromaprint
	media-libs/flac
	media-libs/libebur128
	media-libs/libid3tag
	media-libs/libogg
	media-libs/libsndfile
	media-libs/libsoundtouch
	media-libs/libvorbis
	media-libs/portaudio
	media-libs/portmidi
	media-libs/rubberband
	media-libs/taglib
	media-libs/vamp-plugin-sdk
	sci-libs/fftw:3.0=
	sys-power/upower
	virtual/glu
	virtual/libusb:1
	virtual/opengl
	virtual/udev
	x11-libs/libX11
	aac? (
		media-libs/faad2
		media-libs/libmp4v2:0
	)
	ffmpeg? ( media-video/ffmpeg:0= )
	hid? ( dev-libs/hidapi )
	keyfinder? ( media-libs/libkeyfinder )
	lv2? ( media-libs/lilv )
	mp3? ( media-libs/libmad )
	mp4? ( media-libs/libmp4v2:= )
	opus? (	media-libs/opusfile )
	qtkeychain? ( dev-libs/qtkeychain )
	wavpack? ( media-sound/wavpack )
	"

DEPEND="${RDEPEND}"
BDEPEND="dev-qt/qttest:5
	dev-qt/qtxmlpatterns:5
	virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/mixxx-2.3.1-docs.patch
	"${FILESDIR}"/mixxx-2.3.1-build-type.patch
	"${FILESDIR}"/mixxx-2.3.1-local-manuals.patch
	)

src_prepare() {
	cmake_src_prepare
	eprefixify "${S}"/src/widget/wmainmenubar.cpp
}

src_configure() {
	local mycmakeargs=(
		-DFAAD=$(usex aac on off)
		-DFFMPEG=$(usex ffmpeg on off)
		-DHID=$(usex hid on off)
		-DLILV=$(usex lv2 on off)
		-DMAD=$(usex mp3 on off)
		-DOPTIMIZE=off
		-DCCACHE_SUPPORT=off
		-DOPUS=$(usex opus on off)
		-DBROADCAST=$(usex shout on off)
		-DVINYLCONTROL=on
		-DINSTALL_USER_UDEV_RULES=OFF
		-DWAVPACK=$(usex wavpack on off)
		-DQTKEYCHAIN=$(usex qtkeychain on off)
		-DKEYFINDER=$(usex keyfinder on off)
	)
	cmake_src_configure
}

src_compile() {
	cmake_src_compile
}

src_install() {
	cmake_src_install
	udev_newrules "${S}"/res/linux/mixxx-usb-uaccess.rules 69-mixxx-usb-uaccess.rules

	if use doc ; then
		dodoc README.md res/Mixxx-Keyboard-Shortcuts.pdf
		newdoc "${DISTDIR}/${P}-Manual.pdf" Mixxx-Manual.pdf
	fi
}
