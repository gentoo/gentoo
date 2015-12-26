# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"
inherit eutils flag-o-matic multilib-minimal

MY_PN="gst-libav"
DESCRIPTION="FFmpeg based gstreamer plugin"
HOMEPAGE="http://gstreamer.freedesktop.org/modules/gst-libav.html"
SRC_URI="http://gstreamer.freedesktop.org/src/${MY_PN}/${MY_PN}-${PV}.tar.xz"

LICENSE="GPL-2"
SLOT="1.0"
KEYWORDS="ia64 ppc"
IUSE="libav +orc"

RDEPEND="
	>=media-libs/gstreamer-1.4.0:1.0[${MULTILIB_USEDEP}]
	>=media-libs/gst-plugins-base-1.4.0:1.0[${MULTILIB_USEDEP}]
	!libav? ( >=media-video/ffmpeg-2.2:0=[${MULTILIB_USEDEP}] )
	libav? ( >=media-video/libav-9:0=[${MULTILIB_USEDEP}] )
	orc? ( >=dev-lang/orc-0.4.17[${MULTILIB_USEDEP}] )
"
DEPEND="${RDEPEND}
	app-arch/xz-utils
	>=dev-util/gtk-doc-am-1.12
	>=virtual/pkgconfig-0-r1[${MULTILIB_USEDEP}]
"

S="${WORKDIR}/${MY_PN}-${PV}"

src_prepare() {
	# https://bugzilla.gnome.org/show_bug.cgi?id=743984
	epatch "${FILESDIR}/${PN}-1.4.5-libav9.patch"
}

multilib_src_configure() {
	GST_PLUGINS_BUILD=""
	# always use system ffmpeg/libav if possible
	ECONF_SOURCE=${S} \
	econf \
		--disable-maintainer-mode \
		--with-package-name="Gentoo GStreamer ebuild" \
		--with-package-origin="https://www.gentoo.org" \
		--disable-fatal-warnings \
		--with-system-libav \
		$(use_enable orc)
}

multilib_src_compile() {
	# Don't build with -Werror
	emake ERROR_CFLAGS=
}

multilib_src_install_all() {
	einstalldocs
	prune_libtool_files --modules
}
