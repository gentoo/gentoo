# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
GST_ORG_MODULE=gst-plugins-good

inherit gstreamer-meson

DESCRIPTION="HTTP client source/sink plugin for GStreamer"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~mips ~ppc ~ppc64 ~riscv ~sparc ~x86 ~x64-macos"

# Checks at runtime which libsoup was linked in and picks the appropriate one.
# Need both here to guarantee consumers will work.
# May be able to get rid of 2.4 later if it's possible to build 2.4 support
# from 3.0 headers.
RDEPEND="
	>=net-libs/libsoup-2.48:2.4[${MULTILIB_USEDEP}]
	net-libs/libsoup:3.0[${MULTILIB_USEDEP}]
"
DEPEND="${RDEPEND}"
