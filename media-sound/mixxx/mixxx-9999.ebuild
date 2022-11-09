# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake xdg udev

DESCRIPTION="Advanced Digital DJ tool based on Qt"
HOMEPAGE="https://www.mixxx.org/"
if [[ "${PV}" == *9999 ]] ; then
	inherit git-r3
	if [[ "${PV}" == ?.?.9999 ]] ; then
		EGIT_BRANCH=${PV%.9999}
	fi
	EGIT_REPO_URI="https://github.com/mixxxdj/${PN}.git"
else
	SRC_URI="https://github.com/mixxxdj/${PN}/archive/release-${PV}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}/${PN}-release-${PV}"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="GPL-2"
SLOT="0"
IUSE="aac doc ffmpeg hid keyfinder lv2 mp3 mp4 opus qtkeychain shout wavpack"

RDEPEND="
	dev-db/sqlite
	dev-libs/glib:2
	dev-libs/protobuf:=
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
	media-libs/flac:=
	media-libs/libebur128
	media-libs/libid3tag:=
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
		media-libs/libmp4v2
	)
	ffmpeg? ( media-video/ffmpeg:= )
	hid? ( dev-libs/hidapi )
	keyfinder? ( media-libs/libkeyfinder )
	lv2? ( media-libs/lilv )
	mp3? ( media-libs/libmad )
	mp4? ( media-libs/libmp4v2:= )
	opus? (	media-libs/opusfile )
	qtkeychain? ( dev-libs/qtkeychain )
	shout? ( >=media-libs/libshout-2.4.5 )
	wavpack? ( media-sound/wavpack )
	"

DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig
	dev-qt/qttest:5
	dev-qt/qtxmlpatterns:5"

PATCHES=(
	"${FILESDIR}"/mixxx-9999-docs.patch
	)

src_prepare() {
	cmake_src_prepare
}

src_configure() {

	local mycmakeargs=(
		-DFAAD="$(usex aac on off)"
		-DFFMPEG="$(usex ffmpeg on off)"
		-DHID="$(usex hid on off)"
		-DLILV="$(usex lv2 on off)"
		-DMAD="$(usex mp3 on off)"
		-DOPTIMIZE="off"
		-DCCACHE_SUPPORT="off"
		-DOPUS="$(usex opus on off)"
		-DBROADCAST="$(usex shout on off)"
		-DVINYLCONTROL="on"
		-DINSTALL_USER_UDEV_RULES=OFF
		-DWAVPACK="$(usex wavpack on off)"
		-DQTKEYCHAIN="$(usex qtkeychain on off)"
		-DKEYFINDER="$(usex keyfinder on off)"
	)

	if [[ "${PV}" == 9999 ]] ; then
	local mycmakeargs+=(
		-DENGINEPRIME="OFF"

	)
	fi
	cmake_src_configure
}

src_compile() {
	cmake_src_compile
}

src_install() {
	cmake_src_install
	udev_newrules "${S}"/res/linux/mixxx-usb-uaccess.rules 69-mixxx-usb-uaccess.rules

	if use doc ; then
		dodoc README Mixxx-Manual.pdf
	fi
}

pkg_postinst() {
	xdg_pkg_postinst
	udev_reload
}

pkg_postrm() {
	xdg_pkg_postrm
	udev_reload
}
