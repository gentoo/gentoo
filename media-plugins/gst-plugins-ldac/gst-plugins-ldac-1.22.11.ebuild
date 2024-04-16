# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
GST_ORG_MODULE=gst-plugins-bad

inherit gstreamer-meson

DESCRIPTION="LDAC plugin for GStreamer"
KEYWORDS="~amd64 arm arm64 ~loong ppc ppc64 ~riscv ~x86"

RDEPEND="media-libs/libldac[${MULTILIB_USEDEP}]"
DEPEND="${RDEPEND}"
