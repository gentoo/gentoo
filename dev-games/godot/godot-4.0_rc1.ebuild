# Copyright 2022-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..11} )
inherit bash-completion-r1 desktop optfeature python-any-r1
inherit scons-utils toolchain-funcs xdg

MY_P="${PN}-$(ver_rs 2 -)"

DESCRIPTION="Multi-platform 2D and 3D game engine with a feature-rich editor"
HOMEPAGE="https://godotengine.org/"
SRC_URI="https://downloads.tuxfamily.org/godotengine/$(ver_rs 2 /)/${MY_P}.tar.xz"
S="${WORKDIR}/${MY_P}"

LICENSE="
	MIT
	AFL-2.1 Apache-2.0 BSD Boost-1.0 CC0-1.0 LGPL-2.1+ Unlicense ZLIB
	gui? ( CC-BY-4.0 ) tools? ( OFL-1.1 )"
SLOT="4"
KEYWORDS="~amd64"
# Enable roughly same as upstream by default so it works as expected,
# except raycast (tools-only heavy dependency), and deprecated.
IUSE="debug deprecated +gui raycast +runner test +theora +tools +upnp +vulkan +webp"
# tests need more figuring out, they are still somewhat new and volatile
RESTRICT="test"

# dlopen: libX*,libglvnd
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
	gui? (
		media-libs/libglvnd[X]
		x11-libs/libX11
		x11-libs/libXcursor
		x11-libs/libXext
		x11-libs/libXi
		x11-libs/libXinerama
		x11-libs/libXrandr
		x11-libs/libXrender
		tools? ( raycast? ( media-libs/embree:3 ) )
		vulkan? ( media-libs/vulkan-loader[X] )
	)
	theora? ( media-libs/libtheora )
	tools? ( app-misc/ca-certificates )
	upnp? ( net-libs/miniupnpc:= )
	webp? ( media-libs/libwebp:= )"
DEPEND="
	${RDEPEND}
	tools? ( test? ( dev-cpp/doctest ) )"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${PN}-4.0-musl.patch
	"${FILESDIR}"/${PN}-4.0_beta3-headless-header.patch
	"${FILESDIR}"/${PN}-4.0_beta8-scons.patch
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
		libpng libtheora libvorbis libwebp mbedtls miniupnpc
		pcre2 recastnavigation volk wslay zlib zstd
		# certs: unused by generated header, but scons panics if not found
		# linuxbsd_headers: would /want/ to unbundle these, but it is rather
		# messy given godot has dropped all the pkg-config calls and uses
		# hardcoded paths on top -- on the plus side, removes a real need
		# to have IUSE="alsa dbus fontconfig pulseaudio speech udev" (dlopen)
	)
	rm -r "${unbundle[@]/#/thirdparty/}" || die

	# do symlinks to avoid too much patching with hardcoded header paths
	mkdir thirdparty/lib{vorbis,ogg} || die
	ln -s "${ESYSROOT}"/usr/include thirdparty/zstd || die
	ln -s "${ESYSROOT}"/usr/include/doctest thirdparty/ || die
	ln -s "${ESYSROOT}"/usr/include/ogg thirdparty/libogg/ || die
	ln -s "${ESYSROOT}"/usr/include/vorbis thirdparty/libvorbis/ || die
}

src_compile() {
	local -x GODOT_VERSION_STATUS=$(ver_cut 3-4) # for dev versions only
	local -x BUILD_NAME=gentoo # replaces "custom_build" in version string

	local esconsargs=(
		AR="$(tc-getAR)" CC="$(tc-getCC)" CXX="$(tc-getCXX)"

		progress=no
		verbose=yes

		deprecated=$(usex deprecated)
		#execinfo=$(usex !elibc_glibc) # libexecinfo is not packaged
		opengl3=$(usex gui)
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
		builtin_glslang=yes #879111
		builtin_graphite=no
		builtin_harfbuzz=no
		builtin_icu=no
		builtin_libogg=no
		builtin_libpng=no
		builtin_libtheora=$(usex !theora)
		builtin_libvorbis=no
		builtin_libwebp=$(usex !webp)
		builtin_mbedtls=no
		builtin_miniupnpc=$(usex !upnp)
		builtin_msdfgen=yes # not wired for unbundling nor packaged
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
		module_gridmap_enabled=$(usex deprecated) # fails without deprecated
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

pkg_postinst() {
	xdg_pkg_postinst

	# these use bundled headers then get dlopen()'ed if available, USE=gui
	# itself could technically be a optfeature too but it'd be messy here
	if use gui; then
		optfeature "gamepad connection detection support" virtual/libudev
		optfeature "screensaver and portal desktop handling" sys-apps/dbus
		optfeature "sound support" media-libs/alsa-lib media-libs/libpulse
	fi
	optfeature "system fonts support" media-libs/fontconfig
	optfeature "text-to-speech support" app-accessibility/speech-dispatcher
}
