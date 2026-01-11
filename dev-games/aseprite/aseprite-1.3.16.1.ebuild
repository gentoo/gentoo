# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..14} )

inherit cmake desktop flag-o-matic python-any-r1 toolchain-funcs xdg-utils

SKIA_VER="m124-08a5439a6b"

DESCRIPTION="Animated sprite editor & pixel art tool"
HOMEPAGE="https://www.aseprite.org"
# Use forked skia sources with local shanges
# Precompiled skia required only for icudtl.dat
SRC_URI="https://github.com/aseprite/aseprite/releases/download/v$(ver_cut 1-3 ${PV})/Aseprite-v${PV}-Source.zip
	https://github.com/aseprite/skia/archive/refs/tags/${SKIA_VER}.tar.gz ->
		skia-${SKIA_VER}-aseprite.tar.gz
	https://github.com/aseprite/skia/releases/download/${SKIA_VER}/Skia-Linux-Release-x64.zip ->
		Skia-Linux-Release-x64-${SKIA_VER}.zip
"

# See https://github.com/aseprite/aseprite#license
LICENSE="Aseprite-EULA BSD MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE="test webp"

RESTRICT="bindist mirror !test? ( test )"

COMMON_DEPEND="
	app-arch/libarchive:=
	app-text/cmark:=
	dev-libs/icu:=
	dev-libs/libfmt:=
	dev-libs/tinyxml2:=
	media-libs/fontconfig
	media-libs/freetype
	media-libs/giflib:=
	media-libs/harfbuzz:=[truetype]
	media-libs/libjpeg-turbo:=
	media-libs/libpng:=
	net-misc/curl
	virtual/zlib:=
	virtual/opengl
	x11-libs/libX11
	x11-libs/libXcursor
	x11-libs/libXi
	x11-libs/libxcb:=
	webp? ( media-libs/libwebp:= )
"
RDEPEND="
	${COMMON_DEPEND}
	gnome-extra/zenity
"
DEPEND="
	${COMMON_DEPEND}
	x11-base/xorg-proto"
BDEPEND="
	${PYTHON_DEPS}
	test? ( dev-cpp/gtest )
	app-arch/unzip
	dev-build/gn
	virtual/pkgconfig
"

DOCS=(
	docs/ase-file-specs.md
	docs/gpl-palette-extension.md
	README.md
)

PATCHES=(
	"${FILESDIR}/aseprite-1.3.16.1_shared_libarchive.patch"
	"${FILESDIR}/aseprite-1.3.16.1_shared_json11.patch"
	"${FILESDIR}/aseprite-1.3.16.1_shared_webp.patch"
	"${FILESDIR}/aseprite-1.3.16.1_laf_fixes.patch"
	"${FILESDIR}/aseprite-1.3.16.1_shared_fmt.patch"
	"${FILESDIR}/aseprite-1.3.16.1_shared_tinyxml2.patch"
	"${FILESDIR}/aseprite-1.3.16.1_shared_libjpeg-turbo.patch"
	"${FILESDIR}/aseprite-1.3.16.1_shared_icu.patch"
)

src_unpack() {
	mkdir "${S}" || die
	pushd "${S}" > /dev/null || die
		default
	popd > /dev/null || die
}

src_prepare() {
	cmake_src_prepare
	# Skia: remove custom optimizations
	sed -i -e 's:"\/\/gn\/skia\:optimize",::g' \
		"skia-${SKIA_VER}/gn/BUILDCONFIG.gn" || die
	# Aseprite: don't install targets from third_party projects
	sed -i -e \
		's:add_subdirectory(tga):add_subdirectory(tga EXCLUDE_FROM_ALL):g' \
		src/CMakeLists.txt || die
	sed -i \
		-e 's:add_subdirectory(json11):add_subdirectory(json11 EXCLUDE_FROM_ALL):g' \
		-e 's:add_subdirectory(TinyEXIF):add_subdirectory(TinyEXIF EXCLUDE_FROM_ALL):g' \
			third_party/CMakeLists.txt || die
	# Aseprite: don't use bundled gtest
	sed -i -e '/add_subdirectory(googletest)/d' \
		laf/third_party/CMakeLists.txt || die
	# Fix shebang in thumbnailer
	sed -i -e 's:#!/usr/bin/sh:#!/bin/sh:' \
		src/desktop/linux/aseprite-thumbnailer || die
	# Move icudtl.dat to expected location
	mkdir -p "skia-${SKIA_VER}/third_party/externals/icu/flutter" || die
	cp third_party/externals/icu/flutter/icudtl.dat \
		"skia-${SKIA_VER}/third_party/externals/icu/flutter" || die
}

src_configure() {
	# -Werror=strict-aliasing, -Werror=odr, -Werror=lto-type-mismatch
	# https://bugs.gentoo.org/924692
	# https://github.com/aseprite/aseprite/issues/4413
	#
	# There is a bundled skia that fails with ODR errors. When excluding just
	# skia from testing, aseprite itself failed with strict-aliasing (before
	# upstream PR#84), and when that is disabled, fails again with ODR and
	# lto-type-mismatch issues.
	#
	# There are a lot of issues, so don't trust any fixes without thorough
	# testing.
	filter-lto

	einfo "Skia configuration"
	pushd "skia-${SKIA_VER}" > /dev/null || die
		tc-export AR CC CXX

		passflags() {
			local _f _x
			_f=( ${1} )
			_x="[$(printf '"%s", ' "${_f[@]}")]"
			myconf_gn+=( ${2}="${_x}" )
		}

		local myconf_gn=(
			ar=\"${AR}\"
			cc=\"${CC}\"
			cxx=\"${CXX}\"

			is_official_build=true
			is_component_build=false
			is_debug=false

			skia_use_egl=false
			skia_use_dawn=false
			skia_use_dng_sdk=false
			skia_use_metal=false
			skia_use_wuffs=false

			skia_enable_pdf=false
			skia_enable_svg=false
			skia_enable_skunicode=true
			skia_use_expat=false
			skia_use_ffmpeg=false
			skia_use_fontconfig=true
			skia_use_freetype=true
			skia_use_gl=true
			skia_use_harfbuzz=true
			skia_use_icu=true
			skia_use_libjpeg_turbo_decode=true
			skia_use_libjpeg_turbo_encode=true
			skia_use_libpng_decode=true
			skia_use_libpng_encode=true
			skia_use_libwebp_decode=$(usex webp true false)
			skia_use_libwebp_encode=$(usex webp true false)
			skia_use_lua=false
			skia_use_vulkan=false
			skia_use_x11=false
			skia_use_xps=false
			skia_use_zlib=true
		)

		passflags "${CFLAGS}" extra_cflags_c
		passflags "${CXXFLAGS}" extra_cflags_cc
		passflags "${LDFLAGS}" extra_ldflags
		myconf_gn="${myconf_gn[@]}"
		set -- gn gen --args="${myconf_gn% }" out/Static
		echo "$@"
		"$@" || die
	popd > /dev/null || die

	einfo "Aseprite configuration"
	local mycmakeargs=(
		-DENABLE_CCACHE=OFF
		-DENABLE_DESKTOP_INTEGRATION=ON
		-DENABLE_I18N_STRINGS=OFF
		-DENABLE_SCRIPTING=OFF
		-DENABLE_STEAM=OFF
		-DENABLE_TESTS="$(usex test)"
		-DENABLE_QT_THUMBNAILER=OFF
		-DENABLE_UPDATER=OFF
		-DENABLE_WEBP="$(usex webp)"
		-DLAF_WITH_EXAMPLES=OFF
		-DLAF_WITH_TESTS="$(usex test)"
		-DFULLSCREEN_PLATFORM=ON
		-DSKIA_DIR="${S}/skia-${SKIA_VER}/"
		-DSKIA_LIBRARY_DIR="${S}/skia-${SKIA_VER}/out/Static/"
		-DSKIA_LIBRARY="${S}/skia-${SKIA_VER}/out/Static/libskia.a"
		-DSKSHAPER_LIBRARY="${S}/skia-${SKIA_VER}/out/Static/libskshaper.a"
		-DSKUNICODE_LIBRARY="${S}/skia-${SKIA_VER}/out/Static/libskunicode.a"
		-DUSE_SHARED_CMARK=ON
		-DUSE_SHARED_CURL=ON
		-DUSE_SHARED_FMT=ON
		-DUSE_SHARED_FREETYPE=ON
		-DUSE_SHARED_GIFLIB=ON
		-DUSE_SHARED_HARFBUZZ=ON
		-DUSE_SHARED_JSON11=OFF		# Custom methods added to bundled version
		-DUSE_SHARED_LIBARCHIVE=ON
		-DUSE_SHARED_LIBPNG=ON
		-DUSE_SHARED_PIXMAN=ON
		-DUSE_SHARED_TINYXML=ON
		-DUSE_SHARED_WEBP=ON
		-DUSE_SHARED_ZLIB=ON
	)
	cmake_src_configure
}

src_compile() {
	einfo "Skia compilation"
	pushd "skia-${SKIA_VER}" > /dev/null || die
		eninja -C out/Static
	popd > /dev/null || die

	einfo "Aseprite compilation"
	cmake_src_compile
}

src_install() {
	newicon -s 64 "${S}/data/icons/ase64.png" "${PN}.png"
	cmake_src_install
}

pkg_postinst() {
	xdg_desktop_database_update
	xdg_icon_cache_update
	xdg_mimeinfo_database_update
}

pkg_postrm() {
	xdg_desktop_database_update
	xdg_icon_cache_update
	xdg_mimeinfo_database_update
}
