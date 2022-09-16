# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..10} )
inherit bash-completion-r1 desktop python-any-r1 scons-utils toolchain-funcs xdg

MY_P="${PN}-$(ver_rs 2 -)"

DESCRIPTION="Multi-platform 2D and 3D game engine with a feature-rich editor"
HOMEPAGE="https://godotengine.org/"
SRC_URI="https://downloads.tuxfamily.org/godotengine/$(ver_rs 2 /)/${MY_P}.tar.xz"
S="${WORKDIR}/${MY_P}"

LICENSE="
	MIT
	Apache-2.0 BSD Boost-1.0 CC0-1.0 Unlicense ZLIB
	gui? ( CC-BY-4.0 ) tools? ( OFL-1.1 )"
SLOT="4"
KEYWORDS="~amd64"
# Enable roughly same as upstream by default so it works as expected,
# except raycast (tools-only heavy dependency), and deprecated.
IUSE="
	+dbus debug deprecated +fontconfig +gui pulseaudio raycast
	+runner speech test +theora +tools +udev +upnp +webp"
RESTRICT="!test? ( test ) !tools? ( test ) !webp? ( test )"

# dlopen: alsa-lib,dbus,fontconfig,pulseaudio,speech-dispatcher,udev
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
	fontconfig? ( media-libs/fontconfig )
	gui? (
		dev-util/glslang
		media-libs/alsa-lib
		media-libs/libglvnd[X]
		media-libs/vulkan-loader[X]
		x11-libs/libX11
		x11-libs/libXcursor
		x11-libs/libXext
		x11-libs/libXi
		x11-libs/libXinerama
		x11-libs/libXrandr
		x11-libs/libXrender
		dbus? ( sys-apps/dbus )
		pulseaudio? ( media-libs/libpulse )
		tools? ( raycast? ( media-libs/embree:3 ) )
		udev? ( virtual/udev )
	)
	speech? ( app-accessibility/speech-dispatcher )
	theora? ( media-libs/libtheora )
	tools? ( app-misc/ca-certificates )
	upnp? ( net-libs/miniupnpc:= )
	webp? ( media-libs/libwebp:= )"
DEPEND="
	${RDEPEND}
	gui? (
		dev-util/vulkan-headers
		x11-base/xorg-proto
	)
	tools? ( test? ( dev-cpp/doctest ) )"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${PN}-4.0-musl.patch
	"${FILESDIR}"/${PN}-4.0_alpha14-scons.patch
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
		doctest embree freetype glslang graphite harfbuzz icu4c libogg libpng
		libtheora libvorbis libwebp mbedtls miniupnpc pcre2 recastnavigation
		volk vulkan/include wslay zlib zstd
		# certs: unused by generated header, but scons panics if not found
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
		fontconfig=$(usex fontconfig)
		minizip=yes # uses a modified bundled copy
		opengl3=$(usex gui)
		pulseaudio=$(usex gui $(usex pulseaudio))
		speechd=$(usex speech)
		udev=$(usex gui $(usex udev))
		use_dbus=$(usex gui $(usex dbus))
		use_volk=no # unnecessary when linking directly to libvulkan
		vulkan=$(usex gui) # hard-required and favored by upstream over gles3
		x11=$(usex gui)

		system_certs_path="${EPREFIX}"/etc/ssl/certs/ca-certificates.crt

		# platform/*/detect.py uses builtin_* switches to check if need
		# to link with system libraries, but ignores whether the dep is
		# actually used, so "enable" deleted builtins on disabled deps
		builtin_certs=no
		builtin_embree=$(usex !gui yes $(usex !tools yes $(usex !raycast)))
		builtin_enet=yes # bundled copy is patched for IPv6+DTLS support
		builtin_freetype=no
		builtin_glslang=$(usex !gui)
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
		# also bundled but lacking a builtin_* switch:
		#	amd-fsr, basis_universal, cvtt, etcpak, fonts, glad,
		#	jpeg-compressor, meshoptimizer, minimp3, minizip (patched to
		#	seek in archives), noise, oidn, openxr, spirv-reflect, thorvg,
		#	tinyexr, vhacd, vulkan (minus include/) and the misc directory.

		# modules with optional dependencies, "possible" to disable more but
		# gets messy and breaks all sorts of features (expected enabled)
		module_glslang_enabled=$(usex gui)
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
		optimize=none
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

	if [[ ! ${REPLACING_VERSIONS} ]] && has_version ${CATEGORY}/${PN}:3; then
		elog
		elog "Remember to make backups before opening any Godot <=3.x projects in Godot 4."
		elog "Automated migration is only partial, and it would be difficult to revert."
	fi
}
