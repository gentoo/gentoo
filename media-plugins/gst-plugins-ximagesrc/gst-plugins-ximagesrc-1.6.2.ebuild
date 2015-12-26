# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

GST_ORG_MODULE=gst-plugins-good
inherit gstreamer

DESCRIPTION="GStreamer plugin for X11 video capture stream"

KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE=""

RDEPEND="
	>=x11-libs/libX11-1.6.2[${MULTILIB_USEDEP}]
	>=x11-libs/libXdamage-1.1.4-r1[${MULTILIB_USEDEP}]
	>=x11-libs/libXext-1.3.2[${MULTILIB_USEDEP}]
	>=x11-libs/libXfixes-5.0.1[${MULTILIB_USEDEP}]
"
DEPEND="${RDEPEND}
	>=x11-proto/damageproto-1.2.1-r1[${MULTILIB_USEDEP}]
	>=x11-proto/fixesproto-5.0-r1[${MULTILIB_USEDEP}]
	>=x11-proto/xextproto-7.2.1-r1[${MULTILIB_USEDEP}]
	>=x11-proto/xproto-7.0.24[${MULTILIB_USEDEP}]
"

# xshm is a compile time option of ximage
GST_PLUGINS_BUILD="x xshm"
GST_PLUGINS_BUILD_DIR="ximage"
