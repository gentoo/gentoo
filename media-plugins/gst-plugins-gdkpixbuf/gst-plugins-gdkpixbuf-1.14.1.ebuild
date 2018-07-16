# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
GST_ORG_MODULE=gst-plugins-good

inherit gstreamer

DESCRIPION="Image decoder, overlay and sink plugin for GStreamer"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sh ~sparc ~x86 ~amd64-fbsd ~x86-fbsd"
IUSE=""

RDEPEND=">=x11-libs/gdk-pixbuf-2.30.7:2[${MULTILIB_USEDEP}]"
DEPEND="${RDEPEND}"

GST_PLUGINS_BUILD="gdk_pixbuf"
GST_PLUGINS_BUILD_DIR="gdk_pixbuf"
