# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_HANDBOOK="forceoptional"
ECM_TEST="true"
PVCUT=$(ver_cut 1-3)
KFMIN=6.13.0
QTMIN=6.7.2
inherit ecm flag-o-matic gear.kde.org xdg

DESCRIPTION="Full-featured burning and ripping application based on KDE Frameworks"
HOMEPAGE="https://apps.kde.org/k3b/ https://userbase.kde.org/K3b"

LICENSE="GPL-2 FDL-1.2"
SLOT="6"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~riscv ~x86"
IUSE="dvd ffmpeg flac lame mad musepack sndfile sox taglib vcd vorbis webengine"

REQUIRED_USE="flac? ( taglib ) lame? ( taglib ) sox? ( taglib )"

DEPEND="
	>=dev-qt/qtbase-${QTMIN}:6[dbus,gui,network,widgets,xml]
	>=kde-apps/libkcddb-${PVCUT}:6
	>=kde-frameworks/karchive-${KFMIN}:6
	>=kde-frameworks/kbookmarks-${KFMIN}:6
	>=kde-frameworks/kcmutils-${KFMIN}:6
	>=kde-frameworks/kcompletion-${KFMIN}:6
	>=kde-frameworks/kconfig-${KFMIN}:6
	>=kde-frameworks/kconfigwidgets-${KFMIN}:6
	>=kde-frameworks/kcoreaddons-${KFMIN}:6
	>=kde-frameworks/kfilemetadata-${KFMIN}:6[taglib?]
	>=kde-frameworks/ki18n-${KFMIN}:6
	>=kde-frameworks/kiconthemes-${KFMIN}:6
	>=kde-frameworks/kio-${KFMIN}:6
	>=kde-frameworks/kjobwidgets-${KFMIN}:6
	>=kde-frameworks/knewstuff-${KFMIN}:6
	>=kde-frameworks/knotifications-${KFMIN}:6
	>=kde-frameworks/knotifyconfig-${KFMIN}:6
	>=kde-frameworks/kwidgetsaddons-${KFMIN}:6
	>=kde-frameworks/kxmlgui-${KFMIN}:6
	>=kde-frameworks/solid-${KFMIN}:6
	media-libs/libsamplerate
	dvd? ( media-libs/libdvdread:= )
	ffmpeg? ( >=media-video/ffmpeg-4.4.0:0= )
	flac? ( >=media-libs/flac-1.2:=[cxx] )
	lame? ( media-sound/lame )
	mad? ( media-libs/libmad )
	musepack? ( >=media-sound/musepack-tools-444 )
	sndfile? ( media-libs/libsndfile )
	taglib? ( >=media-libs/taglib-1.5:= )
	vorbis? (
		media-libs/libogg
		media-libs/libvorbis
	)
	webengine? ( >=dev-qt/qtwebengine-${QTMIN}:6 )
"
RDEPEND="${DEPEND}
	app-cdr/cdrdao
	app-cdr/cdrtools
	dev-libs/libburn
	media-sound/cdparanoia
	dvd? ( >=app-cdr/dvd+rw-tools-7 )
	sox? ( media-sound/sox )
	vcd? ( media-video/vcdimager )
"

DOCS+=( ChangeLog {FAQ,PERMISSIONS,README}.txt )

src_configure() {
	# -Werror=odr, -Werror=lto-type-mismatch
	# https://bugs.gentoo.org/924376
	# https://bugs.kde.org/show_bug.cgi?id=492571
	filter-lto

	local mycmakeargs=(
		-DK3B_BUILD_API_DOCS=OFF
		-DK3B_BUILD_EXTERNAL_ENCODER_PLUGIN=ON
		-DK3B_BUILD_WAVE_DECODER_PLUGIN=ON
		-DK3B_ENABLE_HAL_SUPPORT=OFF
		-DK3B_DEBUG=$(usex debug)
		-DK3B_ENABLE_DVD_RIPPING=$(usex dvd)
		-DK3B_BUILD_FFMPEG_DECODER_PLUGIN=$(usex ffmpeg)
		-DK3B_BUILD_FLAC_DECODER_PLUGIN=$(usex flac)
		-DK3B_BUILD_LAME_ENCODER_PLUGIN=$(usex lame)
		-DK3B_BUILD_MAD_DECODER_PLUGIN=$(usex mad)
		-DK3B_BUILD_MUSE_DECODER_PLUGIN=$(usex musepack)
		-DK3B_BUILD_SNDFILE_DECODER_PLUGIN=$(usex sndfile)
		-DK3B_BUILD_SOX_ENCODER_PLUGIN=$(usex sox)
		-DK3B_ENABLE_TAGLIB=$(usex taglib)
		-DK3B_BUILD_OGGVORBIS_DECODER_PLUGIN=$(usex vorbis)
		-DK3B_BUILD_OGGVORBIS_ENCODER_PLUGIN=$(usex vorbis)
		$(cmake_use_find_package webengine Qt6WebEngineWidgets)
	)

	ecm_src_configure
}

pkg_postinst() {
	xdg_pkg_postinst

	elog "If you get warnings on start-up, uncheck the \"Check system"
	elog "configuration\" option in the \"Misc\" settings window."
	elog
	local group=cdrom
	use kernel_linux || group=operator
	elog "Make sure you have proper read/write permissions on optical device(s)."
	elog "Usually, it is sufficient to be in the ${group} group."
}
