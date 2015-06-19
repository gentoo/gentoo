# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/gst-plugins-ladspa/gst-plugins-ladspa-0.10.23.ebuild,v 1.4 2013/02/04 09:57:46 ago Exp $

EAPI="5"

inherit gst-plugins-bad

KEYWORDS="alpha amd64 ~ppc ~ppc64 x86"
IUSE=""

RDEPEND=">=media-libs/ladspa-sdk-1.12-r2"
DEPEND="${RDEPEND}"

src_prepare() {
	gst-plugins10_find_plugin_dir
	# signalprocessor has no .pc
	sed -e "s:\$(top_builddir)/gst-libs/gst/signalprocessor/.*\.la:-lgstsignalprocessor-${SLOT}:" \
		-i Makefile.am Makefile.in || die
}
