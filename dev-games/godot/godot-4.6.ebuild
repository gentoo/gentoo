# Copyright 2022-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..14} )
inherit branding desktop python-any-r1 flag-o-matic scons-utils
inherit shell-completion toolchain-funcs xdg

DESCRIPTION="Multi-platform 2D and 3D game engine with a feature-rich editor"
HOMEPAGE="https://godotengine.org/"
SRC_URI="
	https://downloads.tuxfamily.org/godotengine/${PV}/${P}-stable.tar.xz
	https://github.com/godotengine/godot/releases/download/${PV}-stable/${P}-stable.tar.xz
"
S=${WORKDIR}/${P}-stable

LICENSE="
	MIT
	Apache-2.0 BSD Boost-1.0 CC0-1.0 Unlicense ZLIB
	gui? ( CC-BY-4.0 ) tools? ( OFL-1.1 )
"
SLOT="0"
KEYWORDS="~amd64"
# Enable roughly same as upstream by default so it works as expected,
# except raycast (tools-only heavy dependency), and deprecated.
IUSE="
	accessibility alsa +dbus debug deprecated double-precision +fontconfig
	+gui pulseaudio raycast speech test +sdl +theora +tools +udev +upnp
	+vulkan wayland +webp
"
REQUIRED_USE="wayland? ( gui )"
# TODO: tests still need more figuring out
RESTRICT="test"

# dlopen: libglvnd
RDEPEND="
	app-arch/brotli:=
	app-arch/zstd:=
	dev-games/recastnavigation:=
	dev-libs/icu:=
	dev-libs/libpcre2:=[pcre32]
	media-libs/freetype[brotli,harfbuzz]
	media-libs/harfbuzz:=[icu]
	media-libs/libjpeg-turbo:=
	media-libs/libogg
	media-libs/libpng:=
	media-libs/libvorbis
	>=net-libs/mbedtls-3.6.2-r101:3=
	net-libs/wslay
	virtual/zlib:=
	alsa? ( media-libs/alsa-lib )
	dbus? ( sys-apps/dbus )
	fontconfig? ( media-libs/fontconfig )
	gui? (
		media-libs/libglvnd
		x11-libs/libX11
		x11-libs/libXcursor
		x11-libs/libXext
		x11-libs/libXi
		x11-libs/libXinerama
		x11-libs/libXrandr
		x11-libs/libXrender
		x11-libs/libxkbcommon
		tools? ( raycast? ( media-libs/embree:4 ) )
		vulkan? ( media-libs/vulkan-loader[X,wayland?] )
	)
	pulseaudio? ( media-libs/libpulse )
	sdl? ( media-libs/libsdl3 )
	speech? ( app-accessibility/speech-dispatcher )
	theora? (
		media-libs/libtheora:=
		tools? ( media-libs/libtheora[encode] )
	)
	tools? ( app-misc/ca-certificates )
	udev? ( virtual/udev )
	upnp? ( net-libs/miniupnpc:= )
	wayland? (
		dev-libs/wayland
		gui-libs/libdecor
	)
	webp? ( media-libs/libwebp:= )
"
DEPEND="
	${RDEPEND}
	gui? ( x11-base/xorg-proto )
	tools? ( test? ( dev-cpp/doctest ) )
"
BDEPEND="
	virtual/pkgconfig
	wayland? ( dev-util/wayland-scanner )
"

PATCHES=(
	"${FILESDIR}"/${PN}-4.5-scons.patch
)

src_prepare() {
	default

	# mbedtls normally has mbedtls.pc, but Gentoo's slotted one is mbedtls-3.pc
	sed -E "/pkg-config/s/(mbedtls|mbedcrypto|mbedx509)/&-3/g" \
		-i platform/linuxbsd/detect.py || die

	sed -i "s|pkg-config |$(tc-getPKG_CONFIG) |" platform/linuxbsd/detect.py || die

	# use of builtin_ switches can be messy (see below), delete to be sure
	local unbundle=(
		brotli doctest embree freetype graphite harfbuzz icu4c libjpeg-turbo
		libogg libpng libtheora libvorbis libwebp linuxbsd_headers mbedtls
		miniupnpc pcre2 recastnavigation sdl volk wslay zlib zstd
		# certs: unused by generated header, but scons panics if not found
	)
	rm -r "${unbundle[@]/#/thirdparty/}" || die

	ln -s -- "${ESYSROOT}"/usr/include/doctest thirdparty/ || die
}

src_compile() {
	local -x BUILD_NAME=${BRANDING_OS_ID} # replaces "custom_build" in version

	filter-lto #921017

	local esconsargs=(
		AR="$(tc-getAR)" CC="$(tc-getCC)" CXX="$(tc-getCXX)"

		progress=no
		verbose=yes

		target=$(usex tools editor template_$(usex debug{,} release))
		dev_build=$(usex debug)
		tests=$(usex tools $(usex test)) # bakes in --test in final binary

		# TODO?: libgodot requires a separate build given the executable
		# the library are mutally exculsive and so, unless we really need
		# it, skipping support to ease maintenance at least for now
		#library_type=$(usex libgodot shared_library executable)

		accesskit=$(usex accessibility)
		alsa=$(usex alsa)
		dbus=$(usex dbus)
		deprecated=$(usex deprecated)
		precision=$(usex double-precision double single)
		execinfo=no # not packaged, disables crash handler if non-glibc
		fontconfig=$(usex fontconfig)
		opengl3=$(usex gui)
		pulseaudio=$(usex pulseaudio)
		sdl=$(usex sdl)
		speechd=$(usex speech)
		udev=$(usex udev)
		use_sowrap=no
		use_volk=no # unnecessary when linking directly to libvulkan
		vulkan=$(usex gui $(usex vulkan))
		wayland=$(usex wayland)
		# TODO: retry to add optional USE=X, wayland support is new
		# and gui build is not well wired to handle USE="-X wayland" yet
		x11=$(usex gui)

		system_certs_path="${EPREFIX}"/etc/ssl/certs/ca-certificates.crt

		# platform/*/detect.py uses builtin_* switches to check if need
		# to link with system libraries, but many ignore whether the dep
		# is actually used, so "enable" deleted builtins on disabled deps
		builtin_accesskit=yes # not packaged
		builtin_brotli=no
		builtin_certs=no
		builtin_clipper2=yes # not packaged
		builtin_embree=$(usex !gui yes $(usex !tools yes $(usex !raycast)))
		builtin_enet=yes # bundled copy is patched for IPv6+DTLS support
		builtin_freetype=no
		builtin_glslang=yes #879111 (for now, may revisit if more stable)
		builtin_graphite=no
		builtin_harfbuzz=no
		builtin_icu4c=no
		builtin_libjpeg_turbo=no
		builtin_libogg=no
		builtin_libpng=no
		builtin_libtheora=$(usex !theora)
		builtin_libvorbis=no
		builtin_libwebp=$(usex !webp)
		builtin_mbedtls=no
		builtin_miniupnpc=$(usex !upnp)
		builtin_msdfgen=yes # not wired for unbundling nor packaged
		builtin_openxr=yes # not packaged
		builtin_pcre2=no
		builtin_recastnavigation=no
		builtin_rvo2=yes # bundled copy has godot-specific changes
		builtin_sdl=$(usex !sdl)
		builtin_wslay=no
		builtin_xatlas=yes # not wired for unbundling nor packaged
		builtin_zlib=no
		builtin_zstd=no
		# (more is bundled in third_party/ but they lack builtin_* switches)

		# modules with optional dependencies, "possible" to disable more but
		# gets messy and breaks all sorts of features (expected enabled)
		module_mono_enabled=no # unhandled
		# note raycast is only enabled on amd64+arm64 and USE should
		# be masked for other keywords if added, see raycast/config.py
		module_raycast_enabled=$(usex gui $(usex tools $(usex raycast)))
		module_theora_enabled=$(usex theora)
		module_upnp_enabled=$(usex upnp)
		module_webp_enabled=$(usex webp)

		# let *FLAGS handle these
		debug_symbols=no
		lto=none
		optimize=custom
		use_static_cpp=no
	)

	escons "${esconsargs[@]}"
}

src_test() {
	xdg_environment_reset

	bin/godot* --headless --test || die
}

src_install() {
	# suffix varies depending on arch/features, use wildcard to simplify
	newbin bin/godot* godot

	doman misc/dist/linux/godot.6
	dodoc AUTHORS.md CHANGELOG.md DONORS.md README.md

	if use gui; then
		newicon icon.svg godot.svg
		domenu misc/dist/linux/org.godotengine.Godot.desktop

		insinto /usr/share/metainfo
		doins misc/dist/linux/org.godotengine.Godot.appdata.xml

		insinto /usr/share/mime/application
		doins misc/dist/linux/org.godotengine.Godot.xml
	fi

	newbashcomp misc/dist/shell/godot.bash-completion godot
	newfishcomp misc/dist/shell/godot.fish godot.fish
	newzshcomp misc/dist/shell/_godot.zsh-completion _godot
}
