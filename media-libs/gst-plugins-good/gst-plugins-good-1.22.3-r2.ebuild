# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
GST_ORG_MODULE="gst-plugins-good"

inherit gstreamer-meson

DESCRIPTION="Basepack of plugins for GStreamer"
HOMEPAGE="https://gstreamer.freedesktop.org/"

LICENSE="LGPL-2.1+"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~mips ~ppc ~ppc64 ~riscv ~sparc ~x86"
IUSE="+orc"

# Old media-libs/gst-plugins-ugly blocker for xingmux moving from ugly->good
RDEPEND="
	!<media-libs/gst-plugins-ugly-1.22.3
	>=media-libs/gst-plugins-base-${PV}:${SLOT}[${MULTILIB_USEDEP}]
	>=app-arch/bzip2-1.0.6-r4[${MULTILIB_USEDEP}]
	>=sys-libs/zlib-1.2.8-r1[${MULTILIB_USEDEP}]
	orc? ( >=dev-lang/orc-0.4.33[${MULTILIB_USEDEP}] )
"
DEPEND="${RDEPEND}"
BDEPEND=""

DOCS=( AUTHORS ChangeLog NEWS README.md RELEASE )

# Fixes backported to 1.20.1, to be removed in 1.20.2+
PATCHES=(
)

multilib_src_configure() {
	GST_PLUGINS_NOAUTO="bz2"

	local emesonargs=(
		-Dbz2=enabled

		# gst-plugins-ximagesrc
		-Dximagesrc=disabled
		-Dximagesrc-xshm=disabled
		-Dximagesrc-xfixes=disabled
		-Dximagesrc-xdamage=disabled

		# gst-plugins-v4l2
		-Dv4l2=disabled

		# TODO: These two almost certainly need to be their own
		# gst-plugins-qt5 & qt-plugins-qt6.
		-Dqt5=disabled
		-Dqt6=disabled
	)

	gstreamer_multilib_src_configure
}

multilib_src_install_all() {
	einstalldocs
	find "${ED}" -name '*.la' -delete || die
}
