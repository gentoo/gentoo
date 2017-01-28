# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit cmake-utils git-r3 nsplugins toolchain-funcs

DESCRIPTION="High performance flash player"
HOMEPAGE="http://lightspark.github.io/"
SRC_URI=""
EGIT_REPO_URI="https://github.com/lightspark/lightspark"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS=""
IUSE="cpu_flags_x86_sse2 curl ffmpeg gles libav nsplugin ppapi profile rtmp"

# Note: code-wise llvm-4.0 is fine but due to CMake bug it can't work:
# https://gitlab.kitware.com/cmake/cmake/issues/16606
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
	>=sys-devel/gcc-4.6.0:*[cxx]
	<sys-devel/llvm-4:0=
	>=sys-devel/llvm-3.4:0=
	sys-libs/zlib:0=
	x11-libs/cairo:0=
	x11-libs/gtk+:2=
	x11-libs/libX11:0=
	x11-libs/pango:0=
	virtual/jpeg:0=
	curl? ( net-misc/curl:0= )
	ffmpeg? (
		libav? ( media-video/libav:0= )
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

pkg_pretend() {
	if [[ ${MERGE_TYPE} != binary ]]; then
		if tc-is-gcc && [[ $(gcc-major-version) == 4 && $(gcc-minor-version) -lt 6 || $(gcc-major-version) -lt 4 ]] ; then
			eerror "You need at least sys-devel/gcc-4.6.0"
			die "You need at least sys-devel/gcc-4.6.0"
		fi
	fi
}

src_configure() {
	local mycmakeargs=(
		-DENABLE_CURL=$(usex curl)
		-DENABLE_GLES2=$(usex gles)
		-DENABLE_LIBAVCODEC=$(usex ffmpeg)
		-DENABLE_RTMP=$(usex rtmp)

		-DENABLE_MEMORY_USAGE_PROFILING=$(usex profile)
		-DENABLE_PROFILING=$(usex profile)
		-DENABLE_SSE2=$(usex cpu_flags_x86_sse2)

		-DCOMPILE_PLUGIN=$(usex nsplugin)
		-DPLUGIN_DIRECTORY="${EPREFIX}"/usr/$(get_libdir)/${PN}/plugins
		# TODO: install /etc/chromium file? block adobe-flash?
		-DCOMPILE_PPAPI_PLUGIN=$(usex ppapi)
		-DPPAPI_PLUGIN_DIRECTORY="${EPREFIX}"/usr/$(get_libdir)/chromium-browser/${PN}
	)

	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install

	use nsplugin && inst_plugin /usr/$(get_libdir)/${PN}/plugins/liblightsparkplugin.so
}

pkg_postinst() {
	if use nsplugin && ! has_version www-plugins/gnash; then
		elog "Lightspark now supports gnash fallback for its browser plugin."
		elog "Install www-plugins/gnash to take advantage of it."
	fi
	if use nsplugin && has_version "www-plugins/gnash[nsplugin]"; then
		elog "Having two plugins installed for the same MIME type may confuse"
		elog "Mozilla based browsers. It is recommended to disable the nsplugin"
		elog "USE flag for either gnash or lightspark. For details, see"
		elog "https://bugzilla.mozilla.org/show_bug.cgi?id=581848"
	fi
}
