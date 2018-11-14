# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

GST_ORG_MODULE=gst-plugins-bad
inherit gstreamer

KEYWORDS="alpha amd64 ~arm hppa ~ia64 ppc ppc64 ~sparc x86 ~amd64-fbsd ~amd64-linux ~x86-linux"
IUSE=""

RDEPEND=">=media-sound/musepack-tools-465-r1[${MULTILIB_USEDEP}]"
DEPEND="${RDEPEND}"
