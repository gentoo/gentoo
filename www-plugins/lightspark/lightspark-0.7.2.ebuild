# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-plugins/lightspark/lightspark-0.7.2.ebuild,v 1.1 2013/03/19 13:45:04 chithanh Exp $

EAPI=4
inherit cmake-utils nsplugins multilib toolchain-funcs

DESCRIPTION="High performance flash player"
HOMEPAGE="http://lightspark.sourceforge.net/"
SRC_URI="http://launchpad.net/${PN}/trunk/${P}/+download/${P}.tar.gz"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="curl ffmpeg gles nsplugin profile pulseaudio rtmp sdl"

RDEPEND=">=dev-cpp/libxmlpp-2.33.1:2.6
	>=dev-libs/boost-1.42
	dev-libs/libpcre[cxx]
	media-fonts/liberation-fonts
	media-libs/libpng
	media-libs/libsdl
	>=sys-devel/gcc-4.6.0[cxx]
	>=sys-devel/llvm-3
	<sys-devel/llvm-3.3
	x11-libs/cairo
	x11-libs/gtk+:2
	x11-libs/libX11
	x11-libs/pango
	curl? (
		net-misc/curl
	)
	ffmpeg? (
		virtual/ffmpeg
	)
	!gles? (
		>=media-libs/glew-1.5.3
		virtual/opengl
	)
	gles? (
		media-libs/mesa[gles2]
	)
	pulseaudio? (
		media-sound/pulseaudio
	)
	rtmp? (
		media-video/rtmpdump
	)
	virtual/jpeg"
DEPEND="${RDEPEND}
	amd64? ( dev-lang/nasm )
	x86? ( dev-lang/nasm )
	virtual/pkgconfig"

S=${WORKDIR}/${P/_rc*/}

pkg_pretend() {
	if [[ ${MERGE_TYPE} != binary ]]; then
		if [[ $(gcc-major-version) == 4 && $(gcc-minor-version) -lt 6 || $(gcc-major-version) -lt 4 ]] ; then
			eerror "You need at least sys-devel/gcc-4.6.0"
			die "You need at least sys-devel/gcc-4.6.0"
		fi
	fi
}

src_configure() {
	local audiobackends
	use pulseaudio && audiobackends+="pulse"
	use sdl && audiobackends+="sdl"

	local mycmakeargs=(
		$(cmake-utils_use curl ENABLE_CURL)
		$(cmake-utils_use gles ENABLE_GLES2)
		$(cmake-utils_use ffmpeg ENABLE_LIBAVCODEC)
		$(cmake-utils_use nsplugin COMPILE_PLUGIN)
		$(cmake-utils_use profile ENABLE_MEMORY_USAGE_PROFILING)
		$(cmake-utils_use profile ENABLE_PROFILING)
		$(cmake-utils_use rtmp ENABLE_RTMP)
		-DAUDIO_BACKEND="${audiobackends}"
		-DPLUGIN_DIRECTORY="${EPREFIX}"/usr/$(get_libdir)/${PN}/plugins
	)

	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install

	use nsplugin && inst_plugin /usr/$(get_libdir)/${PN}/plugins/liblightsparkplugin.so

	# default to sdl audio if pulseaudio plugin is not built, bug #406197
	if use sdl && ! use pulseaudio; then
		sed -i 's/backend = pulseaudio/backend = sdl/' "${ED}/etc/xdg/${PN}.conf" || die
	fi
}

pkg_postinst() {
	if use nsplugin && ! has_version www-plugins/gnash; then
		elog "Lightspark now supports gnash fallback for its browser plugin."
		elog "Install www-plugins/gnash to take advantage of it."
	fi
	if use nsplugin && has_version www-plugins/gnash[nsplugin]; then
		elog "Having two plugins installed for the same MIME type may confuse"
		elog "Mozilla based browsers. It is recommended to disable the nsplugin"
		elog "USE flag for either gnash or lightspark. For details, see"
		elog "https://bugzilla.mozilla.org/show_bug.cgi?id=581848"
	fi
}
