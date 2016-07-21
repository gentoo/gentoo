# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"
inherit eutils flag-o-matic multilib-minimal

MY_PN="gst-libav"
DESCRIPTION="FFmpeg based gstreamer plugin"
HOMEPAGE="https://gstreamer.freedesktop.org/modules/gst-libav.html"
SRC_URI="https://gstreamer.freedesktop.org/src/${MY_PN}/${MY_PN}-${PV}.tar.xz"

LICENSE="GPL-2"
SLOT="1.0"
KEYWORDS="alpha amd64 arm hppa ~ia64 ~mips ~ppc ppc64 sparc x86 ~amd64-fbsd ~x86-fbsd"
IUSE="libav +orc"

RDEPEND="
	>=media-libs/gstreamer-1.4.0:1.0[${MULTILIB_USEDEP}]
	>=media-libs/gst-plugins-base-1.4.0:1.0[${MULTILIB_USEDEP}]
	!libav? ( >=media-video/ffmpeg-2.2:0=[${MULTILIB_USEDEP}] )
	libav? ( >=media-video/libav-10:0=[${MULTILIB_USEDEP}] )
	orc? ( >=dev-lang/orc-0.4.17[${MULTILIB_USEDEP}] )
"
DEPEND="${RDEPEND}
	app-arch/xz-utils
	>=dev-util/gtk-doc-am-1.12
	>=virtual/pkgconfig-0-r1[${MULTILIB_USEDEP}]
"

S="${WORKDIR}/${MY_PN}-${PV}"

src_prepare() {
	# Upstream patches
	# avviddec: Error out if we try to allocate a buffer without being negotiated
	epatch "${FILESDIR}"/${P}-allocate-buffer.patch

	# avauddev: Unref decoded AVFrame after we're done with it
	epatch "${FILESDIR}"/${P}-fix-memleak.patch

	# avviddec: Post error message before returning a flow error
	epatch "${FILESDIR}"/${P}-post-error.patch

	# avviddec: Release stream lock while calling avcodec_decode_video2()
	epatch "${FILESDIR}"/${P}-h265-fixes.patch
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
