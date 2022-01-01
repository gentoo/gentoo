# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit multilib-minimal

MY_PN="gstreamer-vaapi"
DESCRIPTION="Hardware accelerated video decoding through VA-API plugin for GStreamer"
HOMEPAGE="https://cgit.freedesktop.org/gstreamer/gstreamer-vaapi"
SRC_URI="https://gstreamer.freedesktop.org/src/${MY_PN}/${MY_PN}-${PV}.tar.xz"

LICENSE="LGPL-2.1+"
SLOT="1.0"
KEYWORDS="~amd64 ~arm64 ~ppc64 x86"
IUSE="+drm +egl gles2 +opengl wayland +X" # Keep default enabled IUSE in sync with gst-plugins-base and libva

# gst-vaapi configure is based around GL platform mainly, unlike gst-plugins-bad that goes by GL API mainly; for less surprises,
# we design gst-vaapi ebuild in terms of GL API as main choice as well, meaning that USE opengl and/or gles2 is required to
# enable opengl support at all and choices get chained from there.
# One or multiple video output are required: drm, x11, glx, egl and/or wayland;
# but GL API is our main trigger, thus USE=egl should be ineffective if neither gles2 or opengl is enabled;
# So "|| ( drm egl opengl wayland X )" would be wrong, because egl isn't built with USE="egl -opengl -gles2", ending up with no video outputs.
# As we ensure at least one working GL output with other REQUIRED_USE, we can put gles2/opengl in REQUIRED_USE instead of egl, solving the issue.
# gles2 API only supported windowing system (on linux) is EGL, so require it
# opengl API only supported windowing systems (on linux) are EGL and GLX, so require one of them (glx is enabled with USE="opengl X")
REQUIRED_USE="
	|| ( drm gles2 opengl wayland X )
	gles2? ( egl )
	opengl? ( || ( egl X ) )
"

# glx doesn't require libva-glx (libva[opengl]) afaics, only by tests/test-display.c
# USE flag behavior:
# 'drm' enables vaapi drm support
# 'egl' enables EGL platform support (but only if also 'opengl||gles2')
# - 'egl' is exposed as a USE flag mainly to get EGL support instead of or in addition to GLX support with desktop GL while keeping it optional for pure GLX cases;
#   it's always required with USE=gles2, thus USE="gles2 opengl X" will require and build desktop GL EGL platform support as well on top of GLX, which doesn't add extra deps at that point.
# 'gles2' enables GLESv2 or GLESv3 based GL API support
# 'opengl' enables desktop OpenGL based GL API support
# 'wayland' enables non-GL Wayland support; wayland EGL support when combined with 'egl' (but only if also 'opengl||gles2')
# 'X' enables non-GL X support; GLX support when combined with 'opengl'
# gst-plugins-bad still needed for codecparsers (GL libraries moved to -base); checked for 1.14 (recheck for 1.16)
GST_REQ="${PV}"
GL_DEPS="
	>=media-libs/gst-plugins-base-${GST_REQ}:${SLOT}[egl?,gles2?,opengl?,wayland?,X?]
	media-libs/mesa[gles2?,egl?,X(+),${MULTILIB_USEDEP}]
"
RDEPEND="
	>=dev-libs/glib-2.40:2[${MULTILIB_USEDEP}]
	>=media-libs/gstreamer-${GST_REQ}:${SLOT}[${MULTILIB_USEDEP}]
	>=media-libs/gst-plugins-base-${GST_REQ}:${SLOT}[${MULTILIB_USEDEP}]
	>=media-libs/gst-plugins-bad-${GST_REQ}:${SLOT}[${MULTILIB_USEDEP}]
	>=x11-libs/libva-1.4.0:=[drm?,wayland?,X?,${MULTILIB_USEDEP}]
	drm? (
		>=virtual/libudev-208:=[${MULTILIB_USEDEP}]
		>=x11-libs/libdrm-2.4.46[${MULTILIB_USEDEP}]
	)
	gles2? ( ${GL_DEPS} )
	opengl? ( ${GL_DEPS} )
	wayland? (
		>=dev-libs/wayland-1.11.0[${MULTILIB_USEDEP}]
		>=dev-libs/wayland-protocols-1.15 )
	X? (
		>=x11-libs/libX11-1.6.2[${MULTILIB_USEDEP}]
		>=x11-libs/libXrandr-1.4.2[${MULTILIB_USEDEP}]
		x11-libs/libXrender[${MULTILIB_USEDEP}] )
"
DEPEND="${RDEPEND}
	>=dev-util/gtk-doc-am-1.12
	virtual/pkgconfig
"

S="${WORKDIR}/${MY_PN}-${PV}"

multilib_src_configure() {
	local myconf=()
	if use opengl || use gles2; then
		myconf+=(
			$(use_enable egl)
			--with-glapi=$(usex opengl 'gl,' '')$(usex gles2 'gles2,gles3' '') # It's fine to have extra commas passed
		)
	else
		myconf+=(
			--disable-egl
			--without-glapi
		)
	fi

	if use opengl && use X; then
		myconf+=( --enable-glx )
	else
		myconf+=( --disable-glx )
	fi

	ECONF_SOURCE=${S} \
	econf \
		--disable-static \
		--disable-debug \
		--disable-examples \
		--enable-encoders \
		$(use_enable drm) \
		$(use_enable X x11) \
		$(use_enable wayland) \
		--without-gtk \
		"${myconf[@]}"
}

multilib_src_install_all() {
	einstalldocs
	find "${ED}" -name '*.la' -delete || die
}
