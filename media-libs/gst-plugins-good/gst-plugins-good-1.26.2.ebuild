# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
GST_ORG_MODULE="gst-plugins-good"

inherit gstreamer-meson

DESCRIPTION="Basepack of plugins for GStreamer"
HOMEPAGE="https://gstreamer.freedesktop.org/"

LICENSE="LGPL-2.1+"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~mips ~ppc ~ppc64 ~riscv ~sparc ~x86"
IUSE="+orc"

# Old media-libs/gst-plugins-ugly blocker for xingmux moving from ugly->good
RDEPEND="
	!<media-libs/gst-plugins-ugly-${PV}:${SLOT}[${MULTILIB_USEDEP}]
	>=media-libs/gst-plugins-base-${PV}:${SLOT}[${MULTILIB_USEDEP}]
	>=app-arch/bzip2-1.0.8-r5[${MULTILIB_USEDEP}]
	>=sys-libs/zlib-1.3.1[${MULTILIB_USEDEP}]
	orc? ( >=dev-lang/orc-0.4.40[${MULTILIB_USEDEP}] )
"
DEPEND="${RDEPEND}"

DOCS=( AUTHORS ChangeLog NEWS README.md RELEASE )

PATCHES=(
		"${FILESDIR}"/0001-disable-flv-video-caps-late-test.patch
	)

multilib_src_configure() {
	# gst/matroska can use bzip2
	GST_PLUGINS_NOAUTO="bz2"

	local emesonargs=(
		-Dbz2=enabled
	)

	gstreamer_multilib_src_configure
}
