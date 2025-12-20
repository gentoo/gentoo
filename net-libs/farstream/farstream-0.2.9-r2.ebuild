# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

GNOME2_EAUTORECONF=yes
inherit gnome2

DESCRIPTION="Audio/video conferencing framework specifically designed for instant messengers"
HOMEPAGE="https://www.freedesktop.org/wiki/Software/Farstream"
SRC_URI="https://freedesktop.org/software/farstream/releases/${PN}/${P}.tar.gz"

LICENSE="LGPL-2.1+"
SLOT="0.2/5" # .so version
KEYWORDS="~alpha amd64 ~arm arm64 ~loong ppc ppc64 ~riscv x86"
IUSE="+introspection test upnp valgrind"

# Tests need shmsink from gst-plugins-bad, which isn't packaged
# FIXME: do an out-of-tree build for tests if USE=-msn
RESTRICT="test"

COMMON_DEPEND="
	>=media-libs/gstreamer-1.4:1.0
	>=media-libs/gst-plugins-base-1.4:1.0
	>=dev-libs/glib-2.40:2
	>=net-libs/libnice-0.1.8
	introspection? ( >=dev-libs/gobject-introspection-1.82.0-r2:= )
	upnp? ( net-libs/gupnp-igd:1.6= )
"
RDEPEND="${COMMON_DEPEND}
	>=media-libs/gst-plugins-bad-1.4:1.0
	>=media-libs/gst-plugins-good-1.4:1.0
	media-plugins/gst-plugins-srtp:1.0
	media-plugins/gst-plugins-libnice:1.0
"
DEPEND="${COMMON_DEPEND}
	${PYTHON_DEPS}
	test? (
		media-libs/gst-plugins-base:1.0[vorbis]
		media-libs/gst-plugins-good:1.0
	)
	valgrind? ( dev-debug/valgrind )
"
BDEPEND="
	dev-util/glib-utils
	>=dev-build/gtk-doc-am-1.18
	virtual/pkgconfig
"

PATCHES=(
	"${FILESDIR}"/${PN}-0.2.9-make43.patch
	# downstream patches thx to Debian; libsoup:2.4 riddance
	"${FILESDIR}"/${P}-gupnp-{1.2,igd-1.6}.patch
)

src_configure() {
	plugins="fsrawconference,fsrtpconference,fsmsnconference,fsrtpxdata,fsfunnel,fsrtcpfilter,fsvideoanyrate"
	gnome2_src_configure \
		--disable-static \
		$(use_enable introspection) \
		$(use_enable upnp gupnp) \
		$(use_enable valgrind) \
		--with-plugins=${plugins}
}

src_compile() {
	# Prevent sandbox violations, bug #539224
	# https://bugzilla.gnome.org/show_bug.cgi?id=744135
	# https://bugzilla.gnome.org/show_bug.cgi?id=744134
	addpredict /dev

	# bug #776175 for -j1
	MAKEOPTS="-j1" gnome2_src_compile
}
