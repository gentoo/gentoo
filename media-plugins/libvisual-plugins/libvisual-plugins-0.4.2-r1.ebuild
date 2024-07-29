# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit multilib-minimal

DESCRIPTION="collection of visualization plugins for use with the libvisual framework"
HOMEPAGE="http://libvisual.org/"
SRC_URI="https://github.com/Libvisual/libvisual/releases/download/${P}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0.4"
KEYWORDS="~alpha amd64 arm ~arm64 ~hppa ~ia64 ~mips ppc ppc64 ~riscv sparc x86"
IUSE="alsa debug gstreamer gtk jack mplayer opengl portaudio pulseaudio"

RDEPEND=">=media-libs/fontconfig-2.10.92[${MULTILIB_USEDEP}]
	~media-libs/libvisual-${PV}[${MULTILIB_USEDEP}]
	>=x11-libs/libX11-1.6.2[${MULTILIB_USEDEP}]
	>=x11-libs/libXext-1.3.2[${MULTILIB_USEDEP}]
	>=x11-libs/libXrender-0.9.8[${MULTILIB_USEDEP}]
	alsa? ( >=media-libs/alsa-lib-1.0.27.2[${MULTILIB_USEDEP}] )
	gstreamer? ( media-libs/gstreamer[${MULTILIB_USEDEP}] )
	gtk? ( x11-libs/gtk+:3[${MULTILIB_USEDEP}] )
	jack? ( virtual/jack[${MULTILIB_USEDEP}] )
	opengl? (
		>=virtual/glu-9.0-r1[${MULTILIB_USEDEP}]
		>=virtual/opengl-7.0-r1[${MULTILIB_USEDEP}]
	)
	portaudio? ( media-libs/portaudio[${MULTILIB_USEDEP}] )
	pulseaudio? ( media-libs/libpulse[${MULTILIB_USEDEP}] )
"
BDEPEND=">=virtual/pkgconfig-0-r1"

DEPEND="${RDEPEND}
	>=x11-libs/libXt-1.1.4[${MULTILIB_USEDEP}]"

DOCS=( AUTHORS ChangeLog NEWS README TODO )

multilib_src_configure() {
	ECONF_SOURCE=${S} \
	econf \
		$(use_enable jack) \
		$(use_enable gtk gdkpixbuf-plugin) \
		$(use_enable gstreamer gstreamer-plugin) \
		$(use_enable alsa) \
		$(use_enable mplayer) \
		--enable-inputdebug \
		$(use_enable opengl gltest) \
		$(use_enable opengl nastyfft) \
		$(use_enable opengl madspin) \
		$(use_enable opengl flower) \
		$(use_enable debug) \
		$(use_enable portaudio) \
		$(use_enable pulseaudio)
}

multilib_src_install_all() {
	einstalldocs
	find "${D}" -name "*.la" -delete || die
}
