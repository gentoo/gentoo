# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit gstreamer-meson

MY_PN="gst-libav"
MY_PV="$(ver_cut 1-3)"
MY_P="${MY_PN}-${MY_PV}"

DESCRIPTION="FFmpeg based gstreamer plugin"
HOMEPAGE="https://gstreamer.freedesktop.org/modules/gst-libav.html"
SRC_URI="https://gstreamer.freedesktop.org/src/${MY_PN}/${MY_P}.tar.xz"
S="${WORKDIR}/${MY_P}"

LICENSE="LGPL-2+"
SLOT="1.0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~mips ~ppc ~ppc64 ~riscv ~x86"

# 1.24.11 unconditionally used new audio channel layouts added in ffmpeg-4.4;
# 1.24.12 will build time check first. As we don't have older in tree anymore, just dep on it.
RDEPEND="
	>=dev-libs/glib-2.64.0:2[${MULTILIB_USEDEP}]
	>=media-libs/gstreamer-${MY_PV}:1.0[${MULTILIB_USEDEP}]
	>=media-libs/gst-plugins-base-${MY_PV}:1.0[${MULTILIB_USEDEP}]
	>=media-video/ffmpeg-4.4:0=[${MULTILIB_USEDEP}]
"
DEPEND="${RDEPEND}"
