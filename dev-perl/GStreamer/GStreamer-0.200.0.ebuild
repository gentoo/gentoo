# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/GStreamer/GStreamer-0.200.0.ebuild,v 1.1 2015/06/21 22:14:46 dilfridge Exp $

EAPI=5

MODULE_AUTHOR=XAOC
MODULE_VERSION=0.20
inherit perl-module

DESCRIPTION="Perl bindings for GStreamer"

LICENSE="LGPL-2.1+"
SLOT="0"
KEYWORDS="~amd64 ~sparc ~x86"
IUSE=""

RDEPEND="
	media-libs/gstreamer:0.10
	>=dev-perl/glib-perl-1.180.0
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	>=dev-perl/ExtUtils-Depends-0.205.0
	>=dev-perl/extutils-pkgconfig-1.70.0
	virtual/pkgconfig
"

SRC_TEST="do parallel"
