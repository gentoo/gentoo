# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit flag-o-matic

MY_PN=RetroArch
MY_P=${MY_PN}-${PV}

DESCRIPTION="Frontend for emulators, game engines and media players"
HOMEPAGE="https://www.retroarch.com/"
SRC_URI="https://github.com/libretro/${MY_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE="alsa cg cpu_flags_x86_sse dbus egl ffmpeg flac freetype gles gles3 kms
	libcaca libusb materialui miniupnpc openal +opengl +ozone pulseaudio
	qt rgui sdl +sdl2 sixel subtitles ssl stripes systemd tinyalsa udev
	vulkan X xrandr xmb xv wayland +zlib"

MENU_REQUIRED_USE="|| ( gles opengl vulkan )"
REQUIRED_USE="
	cg? ( opengl )
	gles? ( egl )
	gles3? ( gles )
	kms? ( egl )
	materialui? (
		${MENU_REQUIRED_USE}
	)
	opengl? ( !gles )
	ozone? ( ${MENU_REQUIRED_USE} )
	rgui? (
		${MENU_REQUIRED_USE}
		|| ( libcaca sdl sdl2 sixel )
	)
	stripes? ( ${MENU_REQUIRED_USE} )
	xmb? ( ${MENU_REQUIRED_USE} )
	sdl? ( !sdl2 )
	xv? ( X )
"

RDEPEND="
	games-emulation/libretro-common-overlays
	games-emulation/libretro-database
	games-emulation/libretro-info
	games-emulation/retroarch-assets

	alsa? ( media-libs/alsa-lib )
	cg? ( media-gfx/nvidia-cg-toolkit )
	gles? ( media-libs/mesa:0=[gles2] )
	ffmpeg? ( virtual/ffmpeg )
	flac? ( media-libs/flac )
	freetype? ( media-libs/freetype )
	kms? (
		media-libs/mesa:0=[gbm]
		x11-libs/libdrm
	)
	libcaca? ( media-libs/libcaca )
	libusb? ( virtual/libusb:= )
	materialui? ( games-emulation/retroarch-assets[materialui] )
	miniupnpc? ( net-libs/miniupnpc )
	openal? ( media-libs/openal )
	opengl? ( virtual/opengl )
	ozone? ( games-emulation/retroarch-assets[ozone] )
	pulseaudio? ( media-sound/pulseaudio )
	qt? (
		dev-libs/openssl:0=
		dev-qt/qtconcurrent:5
		dev-qt/qtcore:5
		dev-qt/qtgui:5
		dev-qt/qtnetwork:5
		dev-qt/qtwidgets:5
	)
	rgui? ( games-emulation/retroarch-assets[rgui] )
	sdl? ( media-libs/libsdl )
	sdl2? ( media-libs/libsdl2 )
	sixel? ( media-libs/libsixel )
	ssl? ( net-libs/mbedtls:= )
	subtitles? ( media-libs/libass )
	systemd? ( sys-apps/systemd )
	udev? ( virtual/udev )
	vulkan? ( media-libs/vulkan-loader[X?,wayland?] )
	X? (
		x11-libs/libX11
		x11-libs/libXext
		x11-libs/libXxf86vm
		x11-libs/libxcb
	)
	xmb? ( games-emulation/retroarch-assets[xmb] )
	xrandr? ( x11-libs/libXrandr )
	xv? ( x11-libs/libXv )
	wayland? (
		dev-libs/wayland
		dev-libs/wayland-protocols
	)
	zlib? ( sys-libs/zlib )
"
DEPEND="${RDEPEND}
	vulkan? ( dev-util/vulkan-headers )
	virtual/pkgconfig"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	default

	# RetroArch's configure is shell script, not autoconf one
	# However it tryes to mimic autoconf configure options
	sed -i -e \
		's#\(''\))\( : ;;\)#\1|--infodir=*|--datadir=*|--localstatedir=*|--libdir=*)\2#g' \
		qb/qb.params.sh || die

	local LIBRETRO_LIB_DIR="${EPREFIX}/usr/$(get_libdir)/libretro"
	local LIBRETRO_DATA_DIR="${EPREFIX}/usr/share/libretro"
	local RETROARCH_DATA_DIR="${EPREFIX}/usr/share/${PN}"
	sed -i \
		-e "s:# \(assets_directory =\):\1 \"${RETROARCH_DATA_DIR}/assets\":g" \
		-e "s:# \(joypad_autoconfig_dir =\):\1 \"${RETROARCH_DATA_DIR}/autoconfig\":g" \
		-e "s:# \(cheat_database_path =\):\1 \"${LIBRETRO_DATA_DIR}/database/cht\":g" \
		-e "s:# \(content_database_path =\):\1 \"${LIBRETRO_DATA_DIR}/database/rdb\":g" \
		-e "s:# \(cursor_directory =\):\1 \"${LIBRETRO_DATA_DIR}/database/cursors\":g" \
		-e "s:# \(libretro_directory =\):\1 \"${LIBRETRO_LIB_DIR}\":g" \
		-e "s:# \(libretro_info_path =\):\1 \"${LIBRETRO_DATA_DIR}/info\":g" \
		-e "s:# \(overlay_directory =\):\1 \"${RETROARCH_DATA_DIR}/overlay\":g" \
		-e "s:# \(video_shader_dir =\):\1 \"${LIBRETRO_DATA_DIR}/shaders\":g" \
		retroarch.cfg || die
}

src_configure() {
	if use cg; then
		append-ldflags -L/opt/nvidia-cg-toolkit/$(get_libdir)
		append-cppflags -I/opt/nvidia-cg-toolkit/include
	fi

	econf \
		--enable-mmap \
		--enable-networking \
		--enable-threads \
		--disable-audioio \
		--disable-builtinflac \
		--disable-builtinmbedtls \
		--disable-builtinminiupnpc \
		--disable-builtinzlib \
		--disable-coreaudio \
		--disable-jack \
		--disable-mpv \
		--disable-oss \
		--disable-roar \
		--disable-rsound \
		--disable-videocore \
		$(use_enable alsa) \
		$(use_enable cg) \
		$(use_enable cpu_flags_x86_sse sse) \
		$(use_enable dbus) \
		$(use_enable egl) \
		$(use_enable freetype) \
		$(use_enable flac) \
		$(use_enable ffmpeg) \
		$(use_enable gles opengles) \
		$(use_enable gles3 opengles3) \
		$(use_enable libcaca caca) \
		$(use_enable libusb) \
		$(use_enable materialui) \
		$(use_enable miniupnpc) \
		$(use_enable openal al) \
		$(use_enable opengl) \
		$(use_enable ozone) \
		$(use_enable pulseaudio pulse) \
		$(use_enable qt) \
		$(use_enable sdl) \
		$(use_enable sdl2) \
		$(use_enable sixel) \
		$(use_enable subtitles ssa) \
		$(use_enable ssl) \
		$(use_enable systemd) \
		$(use_enable tinyalsa) \
		$(use_enable udev) \
		$(use_enable vulkan) \
		$(use_enable wayland) \
		$(use_enable X x11) \
		$(use_enable xrandr) \
		$(use_enable xv xvideo) \
		$(use_enable zlib)
}

pkg_postinst() {
	elog "You should install libretro cores in order to run games."
	elog "NES/Famicon:"
	elog "\tgames-emulation/libretro-nestopia"
	elog "Super Nintendo / Super Famicom:"
	elog "\tgames-emulation/libretro-bsnes"
	elog "Nintendo 64:"
	elog "\tgames-emulation/libretro-mupen64plus-next"
	elog "Game Boy / Game Boy Color:"
	elog "\tgames-emulation/libretro-sameboy"
	elog "Game Boy Advance:"
	elog "\tgames-emulation/libretro-mgba"
	elog "\tgames-emulation/libretro-vbam"
	elog "Nintendo DS / DSi:"
	elog "\tgames-emulation/libretro-desmume"
	elog "Sega Genesis / Mega Drive, CD, MS, GG:"
	elog "\tgames-emulation/libretro-genesis-plus-gx"
	elog "\tgames-emulation/libretro-picodrive"
	elog "Sega Saturn:"
	elog "\tgames-emulation/libretro-yabause"
	elog "\tgames-emulation/libretro-mednafen-saturn"
	elog "Sega Dreamcast:"
	elog "\tgames-emulation/libretro-flycast"
	elog "Sony Playstation:"
	elog "\tgames-emulation/libretro-mednafen-psx"
	elog "NEC PC-FX:"
	elog "\tgames-emulation/libretro-mednafen-pcfx"
	elog ""

	elog "You may want to install shader files via:"
	elog "\tlibretro-common-shaders for Nvidia Cg shaders"
	elog "\tlibretro-glsl-shaders for GLSL shaders"
	elog "\tlibretro-slang-shaders for Vulkan shaders"
}
