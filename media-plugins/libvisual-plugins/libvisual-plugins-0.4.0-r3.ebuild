# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
inherit autotools eutils multilib-minimal

PATCHLEVEL=4

DESCRIPTION="collection of visualization plugins for use with the libvisual framework"
HOMEPAGE="http://libvisual.sourceforge.net/"
SRC_URI="mirror://sourceforge/libvisual/${P}.tar.gz
	mirror://gentoo/${P}-patches-${PATCHLEVEL}.tar.bz2
	mirror://gentoo/${P}-m4-1.tar.bz2"

LICENSE="GPL-2"
SLOT="0.4"
KEYWORDS="~alpha amd64 arm ~arm64 hppa ~ia64 ~mips ppc ppc64 sparc x86"
IUSE="alsa debug gtk jack mplayer opengl"

RDEPEND=">=media-libs/fontconfig-2.10.92[${MULTILIB_USEDEP}]
	~media-libs/libvisual-${PV}[${MULTILIB_USEDEP}]
	>=x11-libs/libX11-1.6.2[${MULTILIB_USEDEP}]
	>=x11-libs/libXext-1.3.2[${MULTILIB_USEDEP}]
	>=x11-libs/libXrender-0.9.8[${MULTILIB_USEDEP}]
	alsa? ( >=media-libs/alsa-lib-1.0.27.2[${MULTILIB_USEDEP}] )
	gtk? ( >=x11-libs/gtk+-2.24.23:2[${MULTILIB_USEDEP}] )
	jack? ( >=media-sound/jack-audio-connection-kit-0.121.3-r1[${MULTILIB_USEDEP}] )
	opengl? (
		>=virtual/glu-9.0-r1[${MULTILIB_USEDEP}]
		>=virtual/opengl-7.0-r1[${MULTILIB_USEDEP}]
	)"
DEPEND="${RDEPEND}
	>=virtual/pkgconfig-0-r1[${MULTILIB_USEDEP}]
	>=x11-libs/libXt-1.1.4[${MULTILIB_USEDEP}]"

DOCS="AUTHORS ChangeLog NEWS README TODO"

src_prepare() {
	EPATCH_SUFFIX=patch epatch "${WORKDIR}"/patches
	AT_M4DIR=${WORKDIR}/m4 eautoreconf

	sed -i -e "s:@MKINSTALLDIRS@:${S}/mkinstalldirs:" po/Makefile.* || die
}

multilib_src_configure() {
	ECONF_SOURCE=${S} \
	econf \
		--disable-esd \
		$(use_enable jack) \
		$(use_enable gtk gdkpixbuf-plugin) \
		--disable-gstreamer-plugin \
		$(use_enable alsa) \
		$(use_enable mplayer) \
		$(use_enable debug inputdebug) \
		$(use_enable opengl gltest) \
		$(use_enable opengl nastyfft) \
		$(use_enable opengl madspin) \
		$(use_enable opengl flower) \
		$(use_enable debug)
}

multilib_src_install_all() {
	einstalldocs
	prune_libtool_files --all
}
