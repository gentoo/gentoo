# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
GST_ORG_MODULE="gst-plugins-bad"

inherit flag-o-matic gstreamer virtualx

DESCRIPTION="Less plugins for GStreamer"
HOMEPAGE="https://gstreamer.freedesktop.org/"

LICENSE="LGPL-2"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86 ~amd64-linux ~x86-linux"

IUSE="X bzip2 +introspection +orc vnc wayland"

# X11 is automagic for now, upstream #709530 - only used by librfb USE=vnc plugin
RDEPEND="
	>=dev-libs/glib-2.40.0:2[${MULTILIB_USEDEP}]
	>=media-libs/gstreamer-${PV}:${SLOT}[${MULTILIB_USEDEP},introspection?]
	>=media-libs/gst-plugins-base-${PV}:${SLOT}[${MULTILIB_USEDEP},introspection?]
	introspection? ( >=dev-libs/gobject-introspection-1.31.1:= )

	bzip2? ( >=app-arch/bzip2-1.0.6-r4[${MULTILIB_USEDEP}] )
	vnc? ( X? ( x11-libs/libX11[${MULTILIB_USEDEP}] ) )
	wayland? (
		>=dev-libs/wayland-1.11.0[${MULTILIB_USEDEP}]
		>=x11-libs/libdrm-2.4.55[${MULTILIB_USEDEP}]
		>=dev-libs/wayland-protocols-1.15
	)

	orc? ( >=dev-lang/orc-0.4.17[${MULTILIB_USEDEP}] )
"

DEPEND="${RDEPEND}
	dev-util/glib-utils
	>=dev-util/gtk-doc-am-1.12
"

RESTRICT="test"

PATCHES=(
	"${FILESDIR}"/${PN}-1.16.2-make43.patch # remove when bumping and switching to Meson
)

src_prepare() {
	default
	addpredict /dev # Prevent sandbox violations bug #570624
}

multilib_src_configure() {
	# Always enable shm (shm_open) and ipcpipeline (sys/socket.h); no extra deps
	gstreamer_multilib_src_configure \
		$(multilib_native_use_enable introspection) \
		$(use_enable bzip2 bz2) \
		$(use_enable orc) \
		$(use_enable vnc librfb) \
		$(use_enable wayland) \
		--disable-examples \
		--disable-debug \
		--without-player-tests \
		--enable-shm \
		--enable-ipcpipeline \
		--disable-gl # eclass probably does this too, but be explicit as it used to be handled in ebuild here; all parts now in gst-plugins-base instead

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
