# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit gst-plugins-base gst-plugins10

KEYWORDS="alpha amd64 arm ia64 ppc ppc64 sh sparc x86 ~x86-fbsd ~x86-freebsd ~amd64-linux ~ia64-linux ~x86-linux ~x86-solaris"
IUSE=""

RDEPEND=">=gnome-base/gnome-vfs-2:2"
DEPEND="${RDEPEND}"

GST_PLUGINS_BUILD="gnome_vfs"

src_prepare() {
	gst-plugins10_system_link \
		gst-libs/gst/tag:gstreamer-tag
}
