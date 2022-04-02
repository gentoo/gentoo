# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
GST_ORG_MODULE=gst-plugins-bad

inherit gstreamer-meson

DESCRIPTION="SRTP encoder/decoder plugin for GStreamer"
KEYWORDS="~alpha amd64 arm arm64 ~ia64 ppc ppc64 ~riscv x86"
IUSE=""

RDEPEND="
	>=net-libs/libsrtp-2.1.0:2=[${MULTILIB_USEDEP}]
"
DEPEND="${RDEPEND}
	dev-util/glib-utils"
