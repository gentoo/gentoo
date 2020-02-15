# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
GST_ORG_MODULE="gst-plugins-good"

inherit flag-o-matic gstreamer

DESCRIPTION="Basepack of plugins for GStreamer"
HOMEPAGE="https://gstreamer.freedesktop.org/"

LICENSE="LGPL-2.1+"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86"
IUSE="+orc"

RDEPEND="
	>=dev-libs/glib-2.40.0:2[${MULTILIB_USEDEP}]
	>=media-libs/gst-plugins-base-${PV}:${SLOT}[${MULTILIB_USEDEP}]
	>=media-libs/gstreamer-${PV}:${SLOT}[${MULTILIB_USEDEP}]
	>=app-arch/bzip2-1.0.6-r4[${MULTILIB_USEDEP}]
	>=sys-libs/zlib-1.2.8-r1[${MULTILIB_USEDEP}]
	orc? ( >=dev-lang/orc-0.4.17[${MULTILIB_USEDEP}] )
"
DEPEND="${RDEPEND}
	>=dev-util/gtk-doc-am-1.12
"

PATCHES=(
	"${FILESDIR}"/${PN}-1.16.2-make43.patch # remove when bumping and switching to Meson
)

multilib_src_configure() {
	# Always enable optional bz2 support for matroska
	# Always enable optional zlib support for qtdemux and matroska
	# Many media files require these to work, as some container headers are often
	# compressed, bug #291154
	gstreamer_multilib_src_configure \
		--enable-bz2 \
		--enable-zlib \
		--disable-examples \
		--with-default-audiosink=autoaudiosink \
		--with-default-visualizer=goom

	if multilib_is_native_abi; then
		ln -s "${S}"/docs/plugins/html docs/plugins/html || die
	fi

}

multilib_src_install_all() {
	DOCS="AUTHORS ChangeLog NEWS README RELEASE"
	einstalldocs
	find "${ED}" -name '*.la' -delete || die
}
