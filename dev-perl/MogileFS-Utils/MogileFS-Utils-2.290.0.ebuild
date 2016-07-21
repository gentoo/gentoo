# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DIST_AUTHOR=DORMANDO
DIST_VERSION=${PV%0.0}
inherit perl-module

DESCRIPTION="Server for the MogileFS distributed file system"

SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

RDEPEND="virtual/perl-IO-Compress
	dev-perl/libwww-perl
	>=dev-perl/MogileFS-Client-1.160.0"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
"
