# Copyright 2022-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

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
	gui? ( CC-BY-4.0 ) tools? ( BitstreamVera OFL-1.1 )"
SLOT="3"
KEYWORDS="~amd64"
# Enable roughly same as upstream by default so it works as expected,
# except raycast (tools-only heavy dependency), and deprecated.
IUSE="
	+bullet debug deprecated +gui pulseaudio raycast +runner +theora
	+tools +udev +upnp +webm +webp"

# dlopen: alsa-lib,pulseaudio,udev
RDEPEND="
	app-arch/zstd:=
	dev-games/recastnavigation:=
	dev-libs/libpcre2:=[pcre32]
	media-libs/alsa-lib
	media-libs/freetype[brotli]
	media-libs/libpng:=
	<net-libs/mbedtls-3:=
	net-libs/wslay
	sys-libs/zlib:=
	bullet? ( sci-physics/bullet:= )
	gui? (
		media-libs/libglvnd
		x11-libs/libX11
		x11-libs/libXcursor
		x11-libs/libXext
		x11-libs/libXi
		x11-libs/libXinerama
		x11-libs/libXrandr
		x11-libs/libXrender
		tools? ( raycast? ( media-libs/embree:3 ) )
	)
	pulseaudio? ( media-libs/libpulse )
	theora? (
		media-libs/libogg
		media-libs/libtheora
		media-libs/libvorbis
	)
	tools? ( app-misc/ca-certificates )
	udev? ( virtual/udev )
	upnp? ( net-libs/miniupnpc:= )
	webm? (
		media-libs/libvorbis
		media-libs/libvpx:=
		media-libs/opus
	)
	webp? ( media-libs/libwebp:= )"
DEPEND="
	${RDEPEND}
	gui? ( x11-base/xorg-proto )"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${PN}-3.5-musl.patch
	"${FILESDIR}"/${PN}-3.5-scons.patch
	"${FILESDIR}"/${PN}-3.5.2-gcc13.patch
)

src_prepare() {
	default

	sed -i "1,5s/ godot/&${SLOT}/i" misc/dist/linux/godot.6 || die
	sed -i "/id/s/Godot/&${SLOT}/" misc/dist/linux/org.godotengine.Godot.appdata.xml || die
	sed -e "s/=godot/&${SLOT}/" -e "/^Name=/s/$/ ${SLOT}/" \
		-i misc/dist/linux/org.godotengine.Godot.desktop || die

	sed -i "s|pkg-config |$(tc-getPKG_CONFIG) |" platform/{x11,server}/detect.py || die

	# use of builtin_ switches can be messy (see below), delete to be sure
	local unbundle=(
		bullet embree freetype libogg libpng libtheora libvorbis libvpx
		libwebp mbedtls miniupnpc opus pcre2 recastnavigation wslay zlib zstd
		# certs: unused by generated header, but scons panics if not found
	)
	rm -r "${unbundle[@]/#/thirdparty/}" || die
}

src_compile() {
	local -x BUILD_NAME=gentoo # replaces "custom_build" in version string

	local esconsargs=(
		AR="$(tc-getAR)" CC="$(tc-getCC)" CXX="$(tc-getCXX)"

		platform=$(usex gui x11 server)
		progress=no
		verbose=yes

		deprecated=$(usex deprecated)
		#execinfo=$(usex !elibc_glibc) # libexecinfo is not packaged
		minizip=yes # uses a modified bundled copy
		pulseaudio=$(usex pulseaudio)
		udev=$(usex udev)

		system_certs_path="${EPREFIX}"/etc/ssl/certs/ca-certificates.crt

		# platform/*/detect.py uses builtin_* switches to check if need
		# to link with system libraries, but ignores whether the dep is
		# actually used, so "enable" deleted builtins on disabled deps
		builtin_bullet=$(usex !bullet)
		builtin_certs=no
		builtin_embree=$(usex !gui yes $(usex !tools yes $(usex !raycast)))
		builtin_enet=yes # bundled copy is patched for IPv6+DTLS support
		builtin_freetype=no
		builtin_libogg=yes # unused
		builtin_libpng=no
		builtin_libtheora=$(usex !theora)
		builtin_libvorbis=$(usex !theora $(usex !webm))
		builtin_libvpx=$(usex !webm)
		builtin_libwebp=$(usex !webp)
		builtin_mbedtls=no
		builtin_miniupnpc=$(usex !upnp)
		builtin_opus=$(usex !webm)
		builtin_pcre2=no
		builtin_recast=no
		builtin_rvo2=yes # bundled copy has godot-specific changes
		builtin_squish=yes # ^ likewise, may not be safe to unbundle
		builtin_wslay=no
		builtin_xatlas=yes # not wired for unbundling nor packaged
		builtin_zlib=no
		builtin_zstd=no
		# (more is bundled in third_party/ but they lack builtin_* switches)

		# modules with optional dependencies, "possible" to disable more but
		# gets messy and breaks all sorts of features (expected enabled)
		module_bullet_enabled=$(usex bullet)
		module_mono_enabled=no # unhandled
		module_ogg_enabled=no # unused
		module_opus_enabled=no # unused, support is gone and webm uses system's
		# note raycast is disabled on many arches, see raycast/config.py
		module_raycast_enabled=$(usex gui $(usex tools $(usex raycast)))
		module_theora_enabled=$(usex theora)
		module_upnp_enabled=$(usex upnp)
		module_vorbis_enabled=no # unused, non-theora/webm uses stb_vorbis
		module_webm_enabled=$(usex webm)
		module_webp_enabled=$(usex webp)

		# let *FLAGS handle these, e.g. can pass -flto as-is
		debug_symbols=no
		optimize=none
		use_lto=no
		use_static_cpp=no
	)

	if use runner && use tools; then
		# build alternate faster + ~60% smaller binary for running
		# games or servers without game development debug paths
		escons extra_suffix=runner target=release tools=no "${esconsargs[@]}"
	fi

	esconsargs+=(
		# debug: debug for godot itself
		# release_debug: debug for game development
		# release: no debugging paths, only available with tools=no
		target=$(usex debug{,} $(usex tools release_debug release))
		tools=$(usex tools)
	)

	escons extra_suffix=main "${esconsargs[@]}"
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
