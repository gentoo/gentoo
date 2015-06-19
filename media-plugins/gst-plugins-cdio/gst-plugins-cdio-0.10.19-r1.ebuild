# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/gst-plugins-cdio/gst-plugins-cdio-0.10.19-r1.ebuild,v 1.7 2014/08/25 11:00:32 ago Exp $

EAPI="5"

GST_ORG_MODULE=gst-plugins-ugly
inherit eutils gstreamer

KEYWORDS="alpha amd64 ~arm ~ia64 ppc ppc64 ~sparc x86 ~amd64-fbsd ~x86-fbsd"
IUSE=""

RDEPEND=">=dev-libs/libcdio-0.90-r1:=[${MULTILIB_USEDEP}]"
DEPEND="${RDEPEND}"

src_prepare() {
	epatch "${FILESDIR}"/${P}-cdio-cd-text-api.patch #452434
}
