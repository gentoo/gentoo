# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/gst-plugins-mad/gst-plugins-mad-1.4.5.ebuild,v 1.6 2015/03/29 11:02:23 jer Exp $

EAPI="5"
GST_ORG_MODULE=gst-plugins-ugly

inherit gstreamer

KEYWORDS="~alpha amd64 ~arm hppa ~ia64 ~mips ppc ppc64 ~sh ~sparc x86 ~amd64-fbsd ~x86-fbsd ~x86-freebsd ~x86-interix ~amd64-linux ~x86-linux"
IUSE=""

RDEPEND=">=media-libs/libmad-0.15.1b-r8[${MULTILIB_USEDEP}]"
DEPEND="${RDEPEND}"
