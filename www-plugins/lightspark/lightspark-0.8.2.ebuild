# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit cmake-utils toolchain-funcs xdg-utils

DESCRIPTION="High performance flash player"
HOMEPAGE="https://lightspark.github.io/"
SRC_URI="https://github.com/lightspark/lightspark/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="cpu_flags_x86_sse2 curl ffmpeg gles libav nsplugin ppapi profile rtmp"

# Note: no LLVM since it's broken upstream
RDEPEND="app-arch/xz-utils:0=
	dev-cpp/glibmm:2=
	>=dev-libs/boost-1.42:0=
	dev-libs/glib:2=
	dev-libs/libpcre:3=[cxx]
	media-fonts/liberation-fonts
	media-libs/freetype:2=
	media-libs/libpng:0=
	media-libs/libsdl2:0=
	media-libs/sdl2-mixer:0=
	sys-libs/zlib:0=
	x11-libs/cairo:0=
	x11-libs/libX11:0=
	x11-libs/pango:0=
	virtual/jpeg:0=
	curl? ( net-misc/curl:0= )
	ffmpeg? (
		libav? ( <media-video/libav-13_pre:0= )
		!libav? ( media-video/ffmpeg:0= )
	)
	gles? ( media-libs/mesa:0=[gles2] )
	!gles? (
		>=media-libs/glew-1.5.3:0=
		virtual/opengl:0=
	)
	rtmp? ( media-video/rtmpdump:0= )"
DEPEND="${RDEPEND}
	amd64? ( dev-lang/nasm )
	x86? ( dev-lang/nasm )
	virtual/pkgconfig"

S=${WORKDIR}/${P/_rc*/}

src_configure() {
	local mycmakeargs=(
		-DENABLE_CURL=$(usex curl)
		-DENABLE_GLES2=$(usex gles)
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

	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install

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
