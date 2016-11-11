# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DIST_AUTHOR=DROLSKY
DIST_VERSION=0.05
inherit perl-module

DESCRIPTION="Fail if tests warn"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="
	virtual/perl-Carp
	>=virtual/perl-Test-Simple-1.302.15
	virtual/perl-parent
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		virtual/perl-File-Spec
		dev-perl/IPC-Run3
		>=dev-perl/Test2-Suite-0.0.15
	)
"
