# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake flag-o-matic toolchain-funcs udev xdg

DESCRIPTION="Advanced Digital DJ tool based on Qt"
HOMEPAGE="https://mixxx.org/"
if [[ ${PV} == *9999 ]] ; then
	inherit git-r3
	if [[ ${PV} == ?.?.9999 ]] ; then
		EGIT_BRANCH=${PV%.9999}
	fi
	EGIT_REPO_URI="https://github.com/mixxxdj/${PN}.git"
else
	SRC_URI="https://github.com/mixxxdj/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~arm64 ~x86"
fi

LICENSE="GPL-2"
SLOT="0"
IUSE="aac benchmark ffmpeg keyfinder lv2 midi modplug mp3 mp4 opus"
IUSE+=" qtkeychain rubberband shout test upower wavpack"
REQUIRED_USE="
	benchmark? ( test )
	qtkeychain? ( shout )
	test? ( aac ffmpeg midi mp3 opus rubberband )
"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-db/sqlite:3
	dev-libs/hidapi
	dev-libs/protobuf:=
	dev-qt/qt5compat:6[qml]
	dev-qt/qtbase:6[concurrent,dbus,gui,icu,network,opengl,sql,sqlite,ssl,widgets,xml,X]
	dev-qt/qtdeclarative:6
	dev-qt/qtshadertools:6
	dev-qt/qtsvg:6
	media-libs/chromaprint:=
	media-libs/flac:=
	media-libs/libebur128:=
	media-libs/libglvnd[X]
	media-libs/libogg
	media-libs/libsndfile
	media-libs/libsoundtouch:=
	media-libs/libvorbis
	media-libs/portaudio
	<media-libs/taglib-2
	media-sound/lame
	virtual/glu
	virtual/libusb:1
	virtual/udev
	x11-libs/libX11
	aac? (
		media-libs/faad2
		media-libs/libmp4v2
	)
	benchmark? (
		dev-cpp/benchmark:=
		dev-cpp/gtest
		dev-util/google-perftools:=
	)
	ffmpeg? ( media-video/ffmpeg:= )
	keyfinder? ( media-libs/libkeyfinder )
	lv2? ( media-libs/lilv )
	midi? ( media-libs/portmidi )
	modplug? ( media-libs/libmodplug )
	mp3? (
		media-libs/libid3tag:=
		media-libs/libmad
	)
	mp4? ( media-libs/libmp4v2 )
	opus? (
		media-libs/opus
		media-libs/opusfile
	)
	qtkeychain? ( >=dev-libs/qtkeychain-0.14.2:=[qt6(+)] )
	rubberband? ( media-libs/rubberband:= )
	shout? ( dev-libs/openssl:= )
	upower? (
		dev-libs/glib:2
		sys-power/upower:=
	)
	wavpack? ( media-sound/wavpack )
"
DEPEND="${RDEPEND}
	dev-cpp/ms-gsl
	test? ( dev-cpp/gtest )
"
BDEPEND="
	dev-util/spirv-tools
	virtual/pkgconfig
"

PATCHES=(
	# Fix strict-aliasing violations in vendored katai_cpp_stl_runtime
	# https://github.com/kaitai-io/kaitai_struct_cpp_stl_runtime/commit/c01f530.patch
	"${FILESDIR}"/${PN}-2.5.0-fix-strict-aliasing-kaitai.patch
)

CMAKE_SKIP_TESTS=(
	# need HID controller
	LegacyControllerMappingValidationTest.HidMappingsValid
	# randomly fails
	# https://github.com/mixxxdj/mixxx/issues/12554
	EngineBufferE2ETest
)

src_configure() {
	# prevent ld error as package builds static libs.
	tc-is-lto && append-flags $(test-flags -ffat-lto-objects)

	local mycmakeargs=(
		-DBATTERY="$(usex upower)"
		-DBROADCAST="$(usex shout)"
		-DBUILD_SHARED_LIBS=ON
		-DBUILD_TESTING="$(usex test)"
		-DBUILD_BENCH="$(usex benchmark)"
		# prevent duplicate call
		-DCCACHE_SUPPORT=OFF
		-DENGINEPRIME=OFF
		-DFAAD="$(usex aac)"
		-DFFMPEG="$(usex ffmpeg)"
		-DGPERFTOOLS="$(usex benchmark)"
		-DGPERFTOOLSPROFILER="$(usex benchmark)"
		-DHID=ON
		-DINSTALL_USER_UDEV_RULES=OFF
		-DKEYFINDER="$(usex keyfinder)"
		-DLILV="$(usex lv2)"
		-DMAD="$(usex mp3)"
		-DMODPLUG="$(usex modplug)"
		-DOPTIMIZE=OFF
		-DOPUS="$(usex opus)"
		-DPORTMIDI="$(usex midi)"
		-DQML=ON
		-DQTKEYCHAIN="$(usex qtkeychain)"
		-DRUBBERBAND="$(usex rubberband)"
		-DVINYLCONTROL=ON
		-DWAVPACK="$(usex wavpack)"
	)

	cmake_src_configure
}

src_install() {
	cmake_src_install
	use benchmark && dobin "${BUILD_DIR}"/mixxx-test
	udev_newrules "${S}"/res/linux/mixxx-usb-uaccess.rules 69-mixxx-usb-uaccess.rules
}

pkg_postinst() {
	xdg_pkg_postinst
	udev_reload

	elog "Manuals are no longer part of the package."
	elog "Please refer to https://downloads.mixxx.org/manual/ for up-to-date manuals."
	if use benchmark; then
		elog ""
		elog "Launch benchmark : ${EROOT}/usr/bin/mixxx-test --benchmark"
		elog "Launch Unittests : ${EROOT}/usr/bin/mixxx-test"
		elog "Some test suites may not be available without source files."
	fi
}

pkg_postrm() {
	xdg_pkg_postrm
	udev_reload
}
