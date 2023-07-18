# Copyright 2022-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..11} )
inherit bash-completion-r1 desktop python-any-r1 scons-utils toolchain-funcs xdg

DESCRIPTION="Multi-platform 2D and 3D game engine with a feature-rich editor"
HOMEPAGE="https://godotengine.org/"
SRC_URI="
	https://downloads.tuxfamily.org/godotengine/${PV}/${P}-stable.tar.xz
	https://github.com/godotengine/godot/releases/download/${PV}-stable/${P}-stable.tar.xz"
S="${WORKDIR}/${P}-stable"

LICENSE="
	MIT
	Apache-2.0 BSD Boost-1.0 CC0-1.0 Unlicense ZLIB
	gui? ( CC-BY-4.0 ) tools? ( OFL-1.1 )"
SLOT="4"
KEYWORDS="~amd64"
# Enable roughly same as upstream by default so it works as expected,
# except raycast (tools-only heavy dependency), and deprecated.
IUSE="
	alsa +dbus debug deprecated +fontconfig +gui pulseaudio raycast
	+runner speech test +theora +tools +udev +upnp +vulkan +webp"
# TODO: tests still need more figuring out
RESTRICT="test"

# dlopen: libglvnd
RDEPEND="
	app-arch/zstd:=
	dev-games/recastnavigation:=
	dev-libs/icu:=
	dev-libs/libpcre2:=[pcre32]
	media-libs/freetype[brotli,harfbuzz]
	media-libs/harfbuzz:=[icu]
	media-libs/libogg
	media-libs/libpng:=
	media-libs/libvorbis
	<net-libs/mbedtls-3:=
	net-libs/wslay
	sys-libs/zlib:=
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
		tools? ( raycast? ( media-libs/embree:3 ) )
		vulkan? ( media-libs/vulkan-loader[X] )
	)
	pulseaudio? ( media-libs/libpulse )
	speech? ( app-accessibility/speech-dispatcher )
	theora? ( media-libs/libtheora )
	tools? ( app-misc/ca-certificates )
	udev? ( virtual/udev )
	upnp? ( net-libs/miniupnpc:= )
	webp? ( media-libs/libwebp:= )"
DEPEND="
	${RDEPEND}
	gui? ( x11-base/xorg-proto )
	tools? ( test? ( dev-cpp/doctest ) )"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${PN}-4.0_beta3-headless-header.patch
	"${FILESDIR}"/${PN}-4.0_rc2-musl.patch
	"${FILESDIR}"/${PN}-4.0_rc3-scons.patch
	"${FILESDIR}"/${P}-xkb-no-sowrap.patch
)

src_prepare() {
	default

	sed -i "1,5s/ godot/&${SLOT}/i" misc/dist/linux/godot.6 || die
	sed -i "/id/s/Godot/&${SLOT}/" misc/dist/linux/org.godotengine.Godot.appdata.xml || die
	sed -e "s/=godot/&${SLOT}/" -e "/^Name=/s/$/ ${SLOT}/" \
		-i misc/dist/linux/org.godotengine.Godot.desktop || die

	sed -i "s|pkg-config |$(tc-getPKG_CONFIG) |" platform/linuxbsd/detect.py || die

	# use of builtin_ switches can be messy (see below), delete to be sure
	local unbundle=(
		doctest embree freetype graphite harfbuzz icu4c libogg
		libpng libtheora libvorbis libwebp linuxbsd_headers mbedtls
		miniupnpc pcre2 recastnavigation volk wslay zlib zstd
		# certs: unused by generated header, but scons panics if not found
	)
	rm -r "${unbundle[@]/#/thirdparty/}" || die

	ln -s "${ESYSROOT}"/usr/include/doctest thirdparty/ || die
}

src_compile() {
	local -x BUILD_NAME=gentoo # replaces "custom_build" in version string

	local esconsargs=(
		AR="$(tc-getAR)" CC="$(tc-getCC)" CXX="$(tc-getCXX)"

		progress=no
		verbose=yes

		use_sowrap=no

		alsa=$(usex alsa)
		dbus=$(usex dbus)
		deprecated=$(usex deprecated)
		fontconfig=$(usex fontconfig)
		opengl3=$(usex gui)
		pulseaudio=$(usex pulseaudio)
		speechd=$(usex speech)
		udev=$(usex udev)
		use_volk=no # unnecessary when linking directly to libvulkan
		vulkan=$(usex gui $(usex vulkan))
		x11=$(usex gui)

		system_certs_path="${EPREFIX}"/etc/ssl/certs/ca-certificates.crt

		# platform/*/detect.py uses builtin_* switches to check if need
		# to link with system libraries, but ignores whether the dep is
		# actually used, so "enable" deleted builtins on disabled deps
		builtin_certs=no
		builtin_embree=$(usex !gui yes $(usex !tools yes $(usex !raycast)))
		builtin_enet=yes # bundled copy is patched for IPv6+DTLS support
		builtin_freetype=no
		builtin_glslang=yes #879111 (for now, may revisit if more stable)
		builtin_graphite=no
		builtin_harfbuzz=no
		builtin_icu4c=no
		builtin_libogg=no
		builtin_libpng=no
		builtin_libtheora=$(usex !theora)
		builtin_libvorbis=no
		builtin_libwebp=$(usex !webp)
		builtin_mbedtls=no
		builtin_miniupnpc=$(usex !upnp)
		builtin_msdfgen=yes # not wired for unbundling nor packaged
		builtin_pcre2=no
		builtin_recastnavigation=no
		builtin_rvo2=yes # bundled copy has godot-specific changes
		builtin_squish=yes # ^ likewise, may not be safe to unbundle
		builtin_wslay=no
		builtin_xatlas=yes # not wired for unbundling nor packaged
		builtin_zlib=no
		builtin_zstd=no
		# (more is bundled in third_party/ but they lack builtin_* switches)

		# modules with optional dependencies, "possible" to disable more but
		# gets messy and breaks all sorts of features (expected enabled)
		module_mono_enabled=no # unhandled
		# note raycast is only enabled on amd64+arm64, see raycast/config.py
		module_raycast_enabled=$(usex gui $(usex tools $(usex raycast)))
		module_theora_enabled=$(usex theora)
		module_upnp_enabled=$(usex upnp)
		module_webp_enabled=$(usex webp)

		# let *FLAGS handle these, e.g. can pass -flto as-is
		debug_symbols=no
		lto=none
		optimize=custom
		use_static_cpp=no
	)

	if use runner && use tools; then
		# build alternate faster + ~60% smaller binary for running
		# games or servers without game development debug paths
		escons extra_suffix=runner target=template_release "${esconsargs[@]}"
	fi

	esconsargs+=(
		target=$(usex tools editor template_$(usex debug{,} release))
		dev_build=$(usex debug)

		# harmless but note this bakes in --test in the final binary
		tests=$(usex tools $(usex test))
	)

	escons extra_suffix=main "${esconsargs[@]}"
}

src_test() {
	xdg_environment_reset
	bin/godot*.main --headless --test || die
}

src_install() {
	local s=godot${SLOT}

	newbin bin/godot*.main ${s}
	if use runner && use tools; then
		newbin bin/godot*.runner ${s}-runner
	else
		# always available, revdeps shouldn't depend on [runner]
		dosym ${s} /usr/bin/${s}-runner
	fi

	newman misc/dist/linux/godot.6 ${s}.6
	dodoc AUTHORS.md CHANGELOG.md DONORS.md README.md

	if use gui; then
		newicon icon.svg ${s}.svg
		newmenu misc/dist/linux/org.godotengine.Godot.desktop \
			org.godotengine.${s^}.desktop

		insinto /usr/share/metainfo
		newins misc/dist/linux/org.godotengine.Godot.appdata.xml \
			org.godotengine.${s^}.appdata.xml

		insinto /usr/share/mime/application
		newins misc/dist/linux/org.godotengine.Godot.xml \
			org.godotengine.${s^}.xml
	fi

	newbashcomp misc/dist/shell/godot.bash-completion ${s}
	bashcomp_alias ${s}{,-runner}

	insinto /usr/share/fish/vendor_completions.d
	newins misc/dist/shell/godot.fish ${s}.fish
	dosym ${s}.fish /usr/share/fish/vendor_completions.d/${s}-runner.fish

	insinto /usr/share/zsh/site-functions
	newins misc/dist/shell/_godot.zsh-completion _${s}
	dosym _${s} /usr/share/zsh/site-functions/_${s}-runner
}
