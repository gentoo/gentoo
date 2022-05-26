# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools meson toolchain-funcs xdg

GLSLANG_COMMIT="bcf6a2430e99e8fc24f9f266e99316905e6d5134"
SPIRV_COMMIT="1458bae62ec67ea7d12c5a13b740e23ed4bb226c"

DESCRIPTION="Super Nintendo Entertainment System (SNES) emulator"
HOMEPAGE="https://github.com/snes9xgit/snes9x/"
SRC_URI="
	https://github.com/snes9xgit/snes9x/archive/${PV}.tar.gz -> ${P}.tar.gz
	gui? ( glslang? (
		https://github.com/KhronosGroup/glslang/archive/${GLSLANG_COMMIT}.tar.gz -> ${P}-glslang.tar.gz
		https://github.com/KhronosGroup/SPIRV-Cross/archive/${SPIRV_COMMIT}.tar.gz -> ${P}-spirv.tar.gz
	) )"

LICENSE="
	Snes9x GPL-2 GPL-2+ LGPL-2.1 LGPL-2.1+ ISC MIT ZLIB
	gui? ( glslang? ( Apache-2.0 BSD ) )"
SLOT="0"
KEYWORDS="~amd64 ~ppc64 ~x86"
IUSE="alsa debug glslang gui libretro netplay opengl oss png portaudio pulseaudio wayland xinerama +xv"
REQUIRED_USE="glslang? ( gui opengl )"
RESTRICT="bindist test" # has no tests but can lead to bug #737044

RDEPEND="
	sys-libs/zlib:=[minizip]
	x11-libs/libX11
	x11-libs/libXext
	alsa? ( media-libs/alsa-lib )
	gui? (
		dev-cpp/cairomm:0
		dev-cpp/glibmm:2
		dev-cpp/gtkmm:3.0[wayland?]
		dev-libs/glib:2
		dev-libs/libsigc++:2
		media-libs/libsdl2[joystick]
		x11-libs/cairo
		x11-libs/gdk-pixbuf:2
		x11-libs/gtk+:3[wayland?]
		x11-libs/libXrandr
		x11-misc/xdg-utils
		opengl? ( media-libs/libepoxy )
		portaudio? ( media-libs/portaudio )
		pulseaudio? ( media-sound/pulseaudio )
		wayland? ( dev-libs/wayland )
	)
	libretro? ( !games-emulation/libretro-snes9x )
	png? ( media-libs/libpng:= )
	xinerama? ( x11-libs/libXinerama )
	xv? ( x11-libs/libXv )"
DEPEND="
	${RDEPEND}
	x11-base/xorg-proto
	opengl? ( media-libs/libglvnd )"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${PN}-1.53-cross-compile.patch
	"${FILESDIR}"/${PN}-1.59-build-system.patch
	"${FILESDIR}"/${PN}-1.61-libretro-flags.patch
)

src_prepare() {
	if use gui && use glslang; then
		rmdir shaders/{glslang,SPIRV-Cross} || die
		mv ../glslang-${GLSLANG_COMMIT} shaders/glslang || die
		mv ../SPIRV-Cross-${SPIRV_COMMIT} shaders/SPIRV-Cross || die
	fi

	default

	rm -r unzip || die

	cd unix || die
	eautoreconf
}

src_configure() {
	tc-export CC CXX # for libretro

	local econfargs=(
		$(use_enable alsa sound-alsa)
		$(use_enable debug debugger)
		$(use_enable netplay)
		$(use_enable png screenshot)
		$(use_enable xinerama)
		$(use_enable xv xvideo)
		--enable-gamepad
		--enable-gzip
		--enable-zip
		--with-system-zip
	)

	cd unix || die
	econf "${econfargs[@]}"

	if use gui; then
		local emesonargs=(
			$(meson_use alsa)
			$(meson_use debug debugger)
			$(meson_use glslang slang) # TODO?: unbundle
			$(meson_use opengl)
			$(meson_use oss)
			$(meson_use png screenshot)
			$(meson_use portaudio)
			$(meson_use pulseaudio)
			$(meson_use wayland)
			$(meson_use xv)
			-Dsystem-zip=true
			-Dzlib=true
		)

		EMESON_SOURCE=${S}/gtk
		meson_src_configure
	fi
}

src_compile() {
	if use libretro; then
		emake -C libretro
		# rebuild objects given libretro uses different defines (bug #791475)
		rm *.o || die
	fi

	emake -C unix

	use gui && meson_src_compile
}

src_install() {
	if use libretro; then
		exeinto /usr/$(get_libdir)/libretro
		doexe libretro/snes9x_libretro.so
	fi

	dobin unix/${PN}

	local DOCS=(
		README.md
		docs/{changes,control-inputs,controls,snapshots}.txt
		unix/snes9x.conf.default
	)
	einstalldocs

	if use gui; then
		meson_src_install
		dodoc gtk/AUTHORS
	fi
}
