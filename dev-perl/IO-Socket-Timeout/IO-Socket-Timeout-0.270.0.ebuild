# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MODULE_AUTHOR=DAMS
MODULE_VERSION=0.27
inherit perl-module

DESCRIPTION="IO::Socket with read/write timeout"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="
	>=dev-perl/PerlIO-via-Timeout-0.280.0
"
DEPEND="${RDEPEND}
	>=dev-perl/Module-Build-Tiny-0.36.0
	>=virtual/perl-ExtUtils-MakeMaker-6.300.0
	virtual/perl-File-Spec
	virtual/perl-IO
	test? (
		virtual/perl-Test-Simple
		dev-perl/Test-TCP
	)
"

mytargets="install"
