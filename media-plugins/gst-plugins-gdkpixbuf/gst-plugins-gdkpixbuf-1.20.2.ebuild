# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
GST_ORG_MODULE=gst-plugins-good

inherit gstreamer-meson

DESCRIPION="Image decoder, overlay and sink plugin for GStreamer"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~mips ppc ~ppc64 ~riscv ~sparc x86"

RDEPEND=">=x11-libs/gdk-pixbuf-2.30.7:2[${MULTILIB_USEDEP}]"
DEPEND="${RDEPEND}"

GST_PLUGINS_ENABLED="gdk-pixbuf"
GST_PLUGINS_BUILD_DIR="gdk_pixbuf"
