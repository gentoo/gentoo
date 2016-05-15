# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DIST_AUTHOR=RJBS
DIST_VERSION=1.08
inherit perl-module

DESCRIPTION="Generic cache interface and implementations"

SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ppc ~ppc64 ~x86 ~x86-solaris"
IUSE=""

RDEPEND="
	>=dev-perl/Digest-SHA1-2.20.0
	>=dev-perl/Error-0.150.0
	>=virtual/perl-File-Spec-0.820.0
	>=dev-perl/IPC-ShareLite-0.90.0
	>=virtual/perl-Storable-1.14.0
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
"
