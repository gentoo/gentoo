# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
GST_ORG_MODULE="gst-plugins-bad"

inherit flag-o-matic gstreamer virtualx

DESCRIPTION="Less plugins for GStreamer"
HOMEPAGE="https://gstreamer.freedesktop.org/"

LICENSE="LGPL-2"
KEYWORDS="alpha amd64 arm arm64 ~hppa ia64 ~mips ppc ppc64 ~sparc x86 ~amd64-linux ~x86-linux"

# TODO: egl and gtk IUSE only for transition
IUSE="X bzip2 +egl gles2 gtk +introspection +opengl +orc vcd vnc wayland" # Keep default IUSE mirrored with gst-plugins-base where relevant

# X11 is automagic for now, upstream #709530 - only used by librfb USE=vnc plugin
# We mirror opengl/gles2 from -base to ensure no automagic openglmixers plugin (with "opengl?" it'd still get built with USE=-opengl here)
RDEPEND="
	>=dev-libs/glib-2.40.0:2[${MULTILIB_USEDEP}]
	>=media-libs/gstreamer-${PV}:${SLOT}[${MULTILIB_USEDEP},introspection?]
	>=media-libs/gst-plugins-base-${PV}:${SLOT}[${MULTILIB_USEDEP},egl?,introspection?,gles2=,opengl=]
	introspection? ( >=dev-libs/gobject-introspection-1.31.1:= )

	bzip2? ( >=app-arch/bzip2-1.0.6-r4[${MULTILIB_USEDEP}] )
	vnc? ( X? ( x11-libs/libX11[${MULTILIB_USEDEP}] ) )
	wayland? (
		>=dev-libs/wayland-1.4.0[${MULTILIB_USEDEP}]
		>=x11-libs/libdrm-2.4.55[${MULTILIB_USEDEP}]
		>=dev-libs/wayland-protocols-1.4
	)

	gtk? ( >=media-plugins/gst-plugins-gtk-${PV}:${SLOT}[${MULTILIB_USEDEP}] )
	orc? ( >=dev-lang/orc-0.4.17[${MULTILIB_USEDEP}] )
"

DEPEND="${RDEPEND}
	dev-util/glib-utils
	>=dev-util/gtk-doc-am-1.12
"

RESTRICT="test"

src_prepare() {
	default
	addpredict /dev # Prevent sandbox violations bug #570624
}

multilib_src_configure() {
	local myconf=()
	if use opengl || use gles2; then
		myconf+=( --enable-gl )
	else
		myconf+=( --disable-gl )
	fi

	# Always enable shm (shm_open) and ipcpipeline (sys/socket.h); no extra deps
	gstreamer_multilib_src_configure \
		$(multilib_native_use_enable introspection) \
		$(use_enable bzip2 bz2) \
		$(use_enable orc) \
		$(use_enable vcd) \
		$(use_enable vnc librfb) \
		$(use_enable wayland) \
		--disable-examples \
		--disable-debug \
		--without-player-tests \
		--enable-shm \
		--enable-ipcpipeline \
		"${myconf[@]}"

	if multilib_is_native_abi; then
		local x
		for x in libs plugins; do
			ln -s "${S}"/docs/${x}/html docs/${x}/html || die
		done
	fi
}

multilib_src_test() {
	unset DISPLAY
	# Tests are slower than upstream expects
	virtx emake check CK_DEFAULT_TIMEOUT=300
}

multilib_src_install_all() {
	DOCS="AUTHORS ChangeLog NEWS README RELEASE"
	einstalldocs
	find "${ED}" -name '*.la' -delete || die
}
