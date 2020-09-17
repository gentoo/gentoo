# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{7..9} )

inherit desktop python-any-r1 scons-utils xdg

DESCRIPTION="Multi-platform 2D and 3D game engine"
HOMEPAGE="http://godotengine.org"

SRC_URI="https://github.com/godotengine/${PN}/archive/${PV}-stable.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${P}-stable"
KEYWORDS="~amd64 ~x86"

LICENSE="Apache-2.0 BSD BSL-1.1 CC-BY-3.0 MIT MPL-2.0 OFL-1.1 public-domain ZLIB"
SLOT="0"
IUSE="+bullet debug +enet +freetype lto +mbedtls +ogg +opus pulseaudio +theora +udev +upnp +vorbis +webp"

RDEPEND="
	app-arch/lz4
	app-arch/zstd
	dev-libs/libpcre2[pcre32]
	media-libs/alsa-lib
	media-libs/libpng:0=
	media-libs/libvpx
	media-libs/mesa[gles2]
	sys-libs/zlib
	x11-libs/libX11
	x11-libs/libXcursor
	x11-libs/libXi
	x11-libs/libXinerama
	virtual/glu
	virtual/opengl
	bullet? ( >=sci-physics/bullet-2.89 )
	enet? ( net-libs/enet:= )
	freetype? ( media-libs/freetype:2 )
	mbedtls? ( net-libs/mbedtls )
	ogg? ( media-libs/libogg )
	opus? (
		media-libs/opus
		media-libs/opusfile
	)
	pulseaudio? ( media-sound/pulseaudio )
	theora? ( media-libs/libtheora )
	udev? ( virtual/udev )
	upnp? ( net-libs/miniupnpc )
	vorbis? ( media-libs/libvorbis )
	webp? ( media-libs/libwebp )
"
DEPEND="
	${RDEPEND}
	dev-lang/yasm
"
BDEPEND="virtual/pkgconfig"

PATCHES=( "${FILESDIR}"/${P}-fix-llvm-build.patch )

src_prepare() {
	default
	rm -r thirdparty/{bullet,enet,freetype,libogg,libpng,libtheora,libvorbis,libvpx,libwebp,mbedtls,miniupnpc,opus,pcre2,zlib,zstd} || die
}

src_configure() {
	myesconsargs=(
		CC="$(tc-getCC)"
		CXX="$(tc-getCXX)"
		AR="$(tc-getAR)"
		RANLIB="$(tc-getRANLIB)"
	)
	# Remove builtin third-party packages, link with system ones instead
	myesconsargs+=(
		builtin_bullet=no
		builtin_enet=no
		builtin_freetype=no
		builtin_libogg=no
		builtin_libpng=no
		builtin_libtheora=no
		builtin_libvorbis=no
		builtin_libvpx=no
		builtin_libwebp=no
		builtin_mbedtls=no
		builtin_miniupnpc=no
		builtin_opus=no
		builtin_pcre2=no
		builtin_pcre2_with_jit=no
		builtin_zlib=no
		builtin_zstd=no
	)
	myesconsargs+=(
		# Mono bindings requires MSBuild which is only available on Windows
		module_mono_enabled=no
		module_bullet_enabled=$(usex bullet)
		module_enet_enabled=$(usex enet)
		module_freetype_enabled=$(usex freetype)
		module_mbedtls_enabled=$(usex mbedtls)
		module_ogg_enabled=$(usex ogg)
		module_opus_enabled=$(usex opus)
		module_theora_enabled=$(usex theora)
		module_upnp_enabled=$(usex upnp)
		module_vorbis_enabled=$(usex vorbis)
		module_webp_enabled=$(usex webp)
	)
	# Misc options
	myesconsargs+=(
		platform=x11
		progress=yes
		tools=yes
		verbose=yes
		pulseaudio=$(usex pulseaudio)
		target=$(usex debug debug release_debug)
		udev=$(usex udev)
		use_lto=$(usex lto)
	)
}

src_compile() {
	escons "${myesconsargs[@]}"
}

src_install() {
	local godot_binary="${PN}.x11.opt.tools"

	if [[ "${ARCH}" == "amd64" ]]; then
		godot_binary="${godot_binary}.64"
	elif [[ "${ARCH}" == "x86" ]]; then
		godot_binary="${godot_binary}.32"
	fi

	newbin bin/${godot_binary} ${PN}
	newicon icon.svg ${PN}.svg
	doman misc/dist/linux/${PN}.6
	domenu misc/dist/linux/org.godotengine.Godot.desktop
	insinto /usr/share/metainfo
	doins misc/dist/linux/org.godotengine.Godot.appdata.xml
	insinto /usr/share/mime/application
	doins misc/dist/linux/x-godot-project.xml
	dodoc AUTHORS.md CHANGELOG.md DONORS.md README.md
}
