# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
GST_ORG_MODULE=gst-plugins-good

inherit gstreamer

DESCRIPTION="HTTP client source/sink plugin for GStreamer"
KEYWORDS="alpha amd64 arm arm64 ~hppa ia64 ~mips ppc ppc64 ~sparc x86 ~x64-macos"
IUSE=""

RDEPEND=">=net-libs/libsoup-2.48:2.4[${MULTILIB_USEDEP}]"
DEPEND="${RDEPEND}"
