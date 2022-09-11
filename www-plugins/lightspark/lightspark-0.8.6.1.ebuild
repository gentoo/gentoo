# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake xdg-utils

DESCRIPTION="High performance flash player"
HOMEPAGE="https://lightspark.github.io/"
SRC_URI="
	https://github.com/lightspark/lightspark/archive/${PV}.tar.gz
		-> ${P}.tar.gz
"
S=${WORKDIR}/${P/_rc*/}

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="cpu_flags_x86_sse2 curl ffmpeg gles2-only nsplugin ppapi profile rtmp"

# Note: no LLVM since it's broken upstream
RDEPEND="
	app-arch/xz-utils:=
	dev-libs/glib
	dev-libs/libpcre:=[cxx]
	media-fonts/liberation-fonts
	media-libs/freetype:=
	media-libs/libjpeg-turbo:=
	media-libs/libpng:=
	media-libs/libsdl2
	media-libs/sdl2-mixer
	sys-libs/zlib:=
	x11-libs/cairo
	x11-libs/libX11
	x11-libs/pango
	curl? ( net-misc/curl:= )
	ffmpeg? ( media-video/ffmpeg:= )
	gles2-only? ( media-libs/mesa:=[gles2] )
	!gles2-only? (
		>=media-libs/glew-1.5.3:=
		virtual/opengl:0=
	)
	rtmp? ( media-video/rtmpdump:= )
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	amd64? ( dev-lang/nasm )
	x86? ( dev-lang/nasm )
	virtual/pkgconfig
"

src_configure() {
	local mycmakeargs=(
		-DENABLE_CURL=$(usex curl)
		-DENABLE_GLES2=$(usex gles2-only)
		-DENABLE_LIBAVCODEC=$(usex ffmpeg)
		-DENABLE_RTMP=$(usex rtmp)

		-DENABLE_MEMORY_USAGE_PROFILING=$(usex profile)
		-DENABLE_PROFILING=$(usex profile)
		-DENABLE_SSE2=$(usex cpu_flags_x86_sse2)

		-DCOMPILE_NPAPI_PLUGIN=$(usex nsplugin)
		-DPLUGIN_DIRECTORY="${EPREFIX}"/usr/$(get_libdir)/${PN}/plugins
		# TODO: install /etc/chromium file? block adobe-flash?
		-DCOMPILE_PPAPI_PLUGIN=$(usex ppapi)
		-DPPAPI_PLUGIN_DIRECTORY="${EPREFIX}"/usr/$(get_libdir)/chromium-browser/${PN}
	)

	cmake_src_configure
}

src_install() {
	cmake_src_install

	if use nsplugin; then
		# copied from nsplugins.eclass, that's broken in EAPI 7
		dodir /usr/$(get_libdir)/nsbrowser/plugins
		dosym ../../lightspark/plugins/liblightsparkplugin.so \
			/usr/$(get_libdir)/nsbrowser/plugins/liblightsparkplugin.so
	fi
}

pkg_postinst() {
	xdg_icon_cache_update
	xdg_desktop_database_update

	if use nsplugin && has_version "www-plugins/gnash[nsplugin]"; then
		elog "Having two plugins installed for the same MIME type may confuse"
		elog "Mozilla based browsers. It is recommended to disable the nsplugin"
		elog "USE flag for either gnash or lightspark. For details, see"
		elog "https://bugzilla.mozilla.org/show_bug.cgi?id=581848"
	fi
}

pkg_postrm() {
	xdg_icon_cache_update
	xdg_desktop_database_update
}
