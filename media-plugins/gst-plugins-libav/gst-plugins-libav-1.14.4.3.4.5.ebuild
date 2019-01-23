# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eapi7-ver multilib-minimal

MY_PN="gst-libav"
MY_PV="$(ver_cut 1-3)"
MY_P="${MY_PN}-${MY_PV}"
FFMPEG_PV="$(ver_cut 4-)"

DESCRIPTION="FFmpeg based gstreamer plugin"
HOMEPAGE="https://gstreamer.freedesktop.org/modules/gst-libav.html"
SRC_URI="https://gstreamer.freedesktop.org/src/${MY_PN}/${MY_P}.tar.xz
	libav? ( https://ffmpeg.org/releases/ffmpeg-${FFMPEG_PV}.tar.bz2 )"

LICENSE="LGPL-2+"
SLOT="1.0"
KEYWORDS="~alpha amd64 arm ~arm64 ~hppa ~ia64 ~mips ppc ppc64 x86 ~amd64-fbsd ~x86-fbsd"
IUSE="libav +orc"

RDEPEND="
	>=dev-libs/glib-2.40.0:2[${MULTILIB_USEDEP}]
	>=media-libs/gstreamer-${MY_PV}:1.0[${MULTILIB_USEDEP}]
	>=media-libs/gst-plugins-base-${MY_PV}:1.0[${MULTILIB_USEDEP}]
	!libav? (
		>=media-video/ffmpeg-3.2.6:0=[${MULTILIB_USEDEP}]
		<media-video/ffmpeg-4 )
	libav? (
		app-arch/bzip2[${MULTILIB_USEDEP}]
		app-arch/xz-utils[${MULTILIB_USEDEP}]
	)
	orc? ( >=dev-lang/orc-0.4.17[${MULTILIB_USEDEP}] )
"
DEPEND="${RDEPEND}
	>=dev-util/gtk-doc-am-1.12
	>=virtual/pkgconfig-0-r1[${MULTILIB_USEDEP}]
"

S="${WORKDIR}/${MY_P}"

RESTRICT="test" # FIXME: tests seem to get stuck at one point; investigate properly

src_unpack() {
	default

	if use libav; then
		# Use newer version of bundled FFmpeg.
		rm -r "${S}/gst-libs/ext/libav" || die
		ln -s ../../../ffmpeg-${FFMPEG_PV} "${S}/gst-libs/ext/libav" || die
	fi
}

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
		ewarn "Using bundled ffmpeg copy as upstream dropped"
		ewarn "the support for compiling against system libav"
		ewarn "https://bugzilla.gnome.org/show_bug.cgi?id=758183"
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
	find "${ED}" -name '*.la' -delete || die
}
