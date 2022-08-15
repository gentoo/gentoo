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
	SRC_URI="https://github.com/mixxxdj/${PN}/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"
	#S="${WORKDIR}/${PN}-release-${PV}"
	KEYWORDS="amd64 x86"
fi
LICENSE="GPL-2"
SLOT="0"
IUSE="aac ffmpeg hid keyfinder lv2 modplug mp3 mp4 opus qtkeychain shout wavpack"

RDEPEND="
	dev-db/sqlite
	dev-libs/glib:2
	dev-libs/protobuf:0=
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
	media-libs/libid3tag:=
	media-libs/libogg
	media-libs/libsndfile
	media-libs/libsoundtouch
	media-libs/libvorbis
	media-libs/portaudio[alsa]
	media-libs/portmidi
	media-libs/rubberband
	media-libs/taglib
	media-libs/vamp-plugin-sdk
	media-sound/lame
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
	modplug? ( media-libs/libmodplug )
	mp3? ( media-libs/libmad )
	mp4? ( media-libs/libmp4v2:= )
	opus? (	media-libs/opusfile )
	qtkeychain? ( dev-libs/qtkeychain )
	wavpack? ( media-sound/wavpack )
	"
	# libshout-idjc-2.4.6 is required. Please check and re-add once it's
	# available in ::gentoo
	# Meanwhile we're using the bundled libshout-idjc. See bug #775443
	#shout? ( >=media-libs/libshout-idjc-2.4.6 )

DEPEND="${RDEPEND}
	dev-qt/qtconcurrent:5
"
BDEPEND="virtual/pkgconfig
	dev-qt/qttest:5
	dev-qt/qtxmlpatterns:5"

PATCHES=(
	"${FILESDIR}"/${PN}-2.3.0-docs.patch
	"${FILESDIR}"/${PN}-2.3.0-cmake.patch
	"${FILESDIR}"/${PN}-2.3.1-benchmark_compile_fix.patch
)

PLOCALES="
	ca cs de en es fi fr gl id it ja kn nl pl pt ro ru sl sq sr tr zh-CN zh-TW
"

mixxx_set_globals() {
	local lang
	local MANUAL_URI_BASE="https://downloads.mixxx.org/manual/$(ver_cut 1-2)"
	for lang in ${PLOCALES} ; do
		SRC_URI+=" l10n_${lang}? ( ${MANUAL_URI_BASE}/${PN}-manual-$(ver_cut 1-2)-${lang/ja/ja-JP}.pdf )"
		IUSE+=" l10n_${lang/ en/ +en}"
	done
	SRC_URI+=" ${MANUAL_URI_BASE}/${PN}-manual-$(ver_cut 1-2)-en.pdf"
}
mixxx_set_globals

src_prepare() {
	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		# Not available on Linux yet and requires additional deps
		-DBATTERY="off"
		-DBROADCAST="$(usex shout on off)"
		-DCCACHE_SUPPORT="off"
		-DFAAD="$(usex aac on off)"
		-DFFMPEG="$(usex ffmpeg on off)"
		-DHID="$(usex hid on off)"
		-DINSTALL_USER_UDEV_RULES=OFF
		-DKEYFINDER="$(usex keyfinder on off)"
		-DLILV="$(usex lv2 on off)"
		-DMAD="$(usex mp3 on off)"
		-DMODPLUG="$(usex modplug on off)"
		-DOPTIMIZE="off"
		-DOPUS="$(usex opus on off)"
		-DQTKEYCHAIN="$(usex qtkeychain on off)"
		-DVINYLCONTROL="on"
		-DWAVPACK="$(usex wavpack on off)"
	)

	if [[ "${PV}" == 9999 ]] ; then
		mycmakeargs+=(
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
	dodoc README.md CHANGELOG.md
	local locale
	for locale in ${PLOCALES} ; do
		if use l10n_${locale} ; then
			dodoc "${DISTDIR}"/${PN}-manual-$(ver_cut 1-2)-${locale/ja/ja-JP}.pdf
		fi
	done
}

pkg_postinst() {
	xdg_pkg_postinst
	udev_reload
}

pkg_postrm() {
	xdg_pkg_postrm
	udev_reload
}
