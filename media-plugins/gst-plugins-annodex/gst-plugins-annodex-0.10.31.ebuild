# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit gst-plugins-good

DESCRIPTION="GStreamer plugin for annodex stream manipulation"
KEYWORDS="alpha amd64 ppc ppc64 x86"
IUSE=""

RDEPEND=">=dev-libs/libxml2-2.4.9"
DEPEND="${RDEPEND}"
