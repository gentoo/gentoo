# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MODULE_AUTHOR=TSCH
MODULE_VERSION=0.06
inherit perl-module

DESCRIPTION="Perl interface to the GStreamer Interfaces library"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 ~sparc x86"
IUSE=""

RDEPEND="=media-libs/gst-plugins-base-0.10*
	>=dev-perl/GStreamer-0.06
	>=dev-perl/glib-perl-1.180"
DEPEND="${RDEPEND}
	>=dev-perl/ExtUtils-Depends-0.205
	>=dev-perl/extutils-pkgconfig-1.07
	virtual/pkgconfig"

SRC_TEST=do
