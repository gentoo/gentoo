# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"
inherit eutils multilib-minimal

MY_PN="gst-libav"
DESCRIPTION="FFmpeg based gstreamer plugin"
HOMEPAGE="http://gstreamer.freedesktop.org/modules/gst-libav.html"
SRC_URI="http://gstreamer.freedesktop.org/src/${MY_PN}/${MY_PN}-${PV}.tar.xz"

LICENSE="GPL-2"
SLOT="1.0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86 ~amd64-fbsd ~x86-fbsd"
IUSE="libav +orc"

# XXX: bzip2/lzma are automagic
RDEPEND="
	app-arch/bzip2
	app-arch/xz-utils
	>=media-libs/gstreamer-${PV}:1.0[${MULTILIB_USEDEP}]
	>=media-libs/gst-plugins-base-${PV}:1.0[${MULTILIB_USEDEP}]
	!libav? ( >=media-video/ffmpeg-2.8.5:0=[${MULTILIB_USEDEP}] )
	orc? ( >=dev-lang/orc-0.4.17[${MULTILIB_USEDEP}] )
"
DEPEND="${RDEPEND}
	>=dev-util/gtk-doc-am-1.12
	>=virtual/pkgconfig-0-r1[${MULTILIB_USEDEP}]
"

S="${WORKDIR}/${MY_PN}-${PV}"

multilib_src_configure() {
	GST_PLUGINS_BUILD=""
	# Upstream dropped support for system libav and won't work
	# for preserving its compat anymore, forcing us to rely on internal
	# ffmpeg copy if we don't want to cause unresolvable blockers for
	# libav setups.
	# https://bugzilla.gnome.org/show_bug.cgi?id=758183
	# Prefer system ffmpeg for -libav
	local myconf

	if use libav; then
		ewarn "Using internal ffmpeg copy as upstream dropped the"
		ewarn "the support for compiling against system libav"
		ewarn "http://bugzilla.gnome.org/show_bug.cgi?id=758183"
	else
		myconf="--with-system-libav"
	fi

	ECONF_SOURCE=${S} \
	econf \
		--disable-maintainer-mode \
		--with-package-name="Gentoo GStreamer ebuild" \
		--with-package-origin="https://www.gentoo.org" \
		--disable-fatal-warnings \
		$(use_enable orc) \
		${myconf}
}

multilib_src_compile() {
	# Don't build with -Werror
	emake ERROR_CFLAGS=
}

multilib_src_install_all() {
	einstalldocs
	prune_libtool_files --modules
}
