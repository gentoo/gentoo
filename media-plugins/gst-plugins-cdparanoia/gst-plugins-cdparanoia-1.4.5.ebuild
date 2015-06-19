# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/gst-plugins-cdparanoia/gst-plugins-cdparanoia-1.4.5.ebuild,v 1.6 2015/03/29 10:51:22 jer Exp $

EAPI="5"

GST_ORG_MODULE=gst-plugins-base
inherit gstreamer

KEYWORDS="~alpha amd64 ~arm hppa ~ia64 ppc ppc64 ~sparc x86"
IUSE=""

RDEPEND=">=media-sound/cdparanoia-3.10.2-r6[${MULTILIB_USEDEP}]"
DEPEND="${RDEPEND}"

src_prepare() {
	gstreamer_system_link gst-libs/gst/audio:gstreamer-audio
}
