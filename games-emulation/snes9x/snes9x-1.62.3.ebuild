# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..13} )
inherit autotools cmake flag-o-matic python-any-r1 toolchain-funcs xdg

# TODO: try unbundling, albeit compatibility with (and between) these
# tend to be volatile and it may not be the best idea "yet"
HASH_GLSLANG=6d41bb9c557c5a0eec61ffba1f775dc5f717a8f7
HASH_SPIRV=4e2fdb25671c742a9fbe93a6034eb1542244c7e1
HASH_VULKAN=a3dd2655a3a68c2a67c55a0f8b77dcb8b166ada2

DESCRIPTION="Super Nintendo Entertainment System (SNES) emulator"
HOMEPAGE="https://github.com/snes9xgit/snes9x/"
SRC_URI="
	https://github.com/snes9xgit/snes9x/archive/${PV}.tar.gz -> ${P}.tar.gz
	gui? (
		https://github.com/KhronosGroup/glslang/archive/${HASH_GLSLANG}.tar.gz
			-> glslang-${HASH_GLSLANG}.tar.gz
		https://github.com/KhronosGroup/SPIRV-Cross/archive/${HASH_SPIRV}.tar.gz
			-> spirv-cross-${HASH_SPIRV}.tar.gz
		https://github.com/KhronosGroup/Vulkan-Headers/archive/${HASH_VULKAN}.tar.gz
			-> vulkan-headers-${HASH_VULKAN}.tar.gz
	)"

LICENSE="
	Snes9x GPL-2 GPL-2+ LGPL-2.1 LGPL-2.1+ ISC MIT ZLIB
	gui? ( Apache-2.0 CC0-1.0 BSD )"
SLOT="0"
KEYWORDS="~amd64 ~ppc64 ~x86"
IUSE="alsa debug gui libretro netplay oss portaudio pulseaudio wayland xinerama +xv"
RESTRICT="bindist"

RDEPEND="
	media-libs/libpng:=
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
		media-libs/libepoxy
		media-libs/libsdl2[joystick]
		x11-libs/cairo
		x11-libs/gdk-pixbuf:2
		x11-libs/gtk+:3[wayland?]
		x11-libs/libXrandr
		portaudio? ( media-libs/portaudio )
		pulseaudio? ( media-libs/libpulse )
		wayland? ( dev-libs/wayland )
	)
	libretro? ( !games-emulation/libretro-snes9x )
	xinerama? ( x11-libs/libXinerama )
	xv? ( x11-libs/libXv )
"
DEPEND="
	${RDEPEND}
	x11-base/xorg-proto
"
BDEPEND="
	virtual/pkgconfig
	gui? ( ${PYTHON_DEPS} )
"

PATCHES=(
	"${FILESDIR}"/${PN}-1.62.1-flags.patch
	"${FILESDIR}"/${PN}-1.62.1-gcc13.patch
	"${FILESDIR}"/${PN}-1.62.1-optional-wayland.patch
)

pkg_setup() {
	# used by bundled glslang
	use gui && python-any-r1_pkg_setup
}

src_prepare() {
	if use gui; then
		rmdir external/{glslang,SPIRV-Cross,vulkan-headers} || die
		mv ../glslang-${HASH_GLSLANG} external/glslang || die
		mv ../SPIRV-Cross-${HASH_SPIRV} external/SPIRV-Cross || die
		mv ../Vulkan-Headers-${HASH_VULKAN} external/vulkan-headers || die
	fi

	if use gui; then
		CMAKE_USE_DIR=${S}/gtk
		cmake_src_prepare
	else
		default
	fi

	pushd unix >/dev/null || die
	eautoreconf
	popd >/dev/null || die

	rm -r unzip || die
}

src_configure() {
	tc-export CC CXX # for libretro

	local econfargs=(
		$(use_enable alsa sound-alsa)
		$(use_enable debug debugger)
		$(use_enable netplay)
		$(use_enable xinerama)
		$(use_enable xv xvideo)
		--enable-gamepad
		--enable-gzip
		--enable-screenshot
		--enable-zip
		--disable-libyuv # unpackaged
		--with-system-zip
	)

	pushd unix >/dev/null || die
	econf "${econfargs[@]}"
	popd >/dev/null || die

	if use gui; then
		# bundled SPIRV-Cross fails with -Werror=odr
		filter-lto

		local mycmakeargs=(
			-DBUILD_SHARED_LIBS=no
			-DDEBUGGER=$(usex debug)
			-DUSE_ALSA=$(usex alsa)
			-DUSE_OSS=$(usex oss)
			-DUSE_PORTAUDIO=$(usex portaudio)
			-DUSE_PULSEAUDIO=$(usex pulseaudio)
			-DUSE_SYSTEMZIP=yes
			-DUSE_WAYLAND=$(usex wayland)
			-DUSE_XV=$(usex xv)

			# this controls both vulkan output and shader support, could be
			# behind a USE but it currently fails to build if disabled and
			# adds no dependencies given they are bundled (for now)
			-DUSE_SLANG=yes

			# gets used for LOCALE/DATADIR too early (installs to /usr//locale)
			-DCMAKE_INSTALL_DATAROOTDIR=share
		)

		cmake_src_configure
	fi
}

src_compile() {
	if use libretro; then
		emake -C libretro LTO=
		# rebuild objects given libretro uses different defines (bug #791475)
		rm *.o || die
	fi

	emake -C unix

	use gui && cmake_src_compile
}

src_test() {
	# currently no tests, but don't run the cmake phase while unconfigured
	use gui && cmake_src_test
}

src_install() {
	if use libretro; then
		exeinto /usr/$(get_libdir)/libretro
		doexe libretro/snes9x_libretro.so
	fi

	dobin unix/snes9x

	local DOCS=(
		README.md
		docs/{changes,control-inputs,controls,snapshots}.txt
		unix/snes9x.conf.default
	)
	einstalldocs

	if use gui; then
		DOCS=( AUTHORS )
		cmake_src_install
	fi
}
