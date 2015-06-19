# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/gst-plugins-ladspa/gst-plugins-ladspa-0.10.23-r1.ebuild,v 1.5 2014/08/25 11:01:12 ago Exp $

EAPI="5"

GST_ORG_MODULE=gst-plugins-bad
inherit gstreamer

KEYWORDS="alpha amd64 ~ppc ~ppc64 x86"
IUSE=""

RDEPEND=">=media-libs/ladspa-sdk-1.13-r2[${MULTILIB_USEDEP}]"
DEPEND="${RDEPEND}"

src_prepare() {
	local pdir=$(gstreamer_get_plugin_dir)

	# signalprocessor has no .pc
	sed -e "s:\$(top_builddir)/gst-libs/gst/signalprocessor/.*\.la:-lgstsignalprocessor-${SLOT}:" \
		-i "${pdir}"/Makefile.{am,in} || die
}
