# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MODULE_AUTHOR=DAMS
MODULE_VERSION=0.29
inherit perl-module

DESCRIPTION="PerlIO layer that adds read & write timeout to a handle"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="
	>=virtual/perl-Exporter-5.570.0
	virtual/perl-Scalar-List-Utils
	dev-perl/Time-Out
"
DEPEND="
	>=dev-perl/Module-Build-Tiny-0.30.0
	>=virtual/perl-ExtUtils-MakeMaker-6.300.0
	virtual/perl-File-Spec
	virtual/perl-IO
	test? (
		virtual/perl-Test-Simple
		dev-perl/Test-TCP
	)
"

mytargets="install"
