# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MODULE_AUTHOR=NIERLEIN
MODULE_VERSION=0.39
inherit perl-module

DESCRIPTION="Modules to streamline Nagios, Icinga, Shinken, etc. plugins"

SLOT="0"
KEYWORDS="~amd64 ~hppa ~x86"
IUSE="test"

RDEPEND="
	virtual/perl-Carp
	dev-perl/Class-Accessor
	dev-perl/Config-Tiny
	virtual/perl-File-Spec
	dev-perl/Math-Calc-Units
	dev-perl/Params-Validate
"
DEPEND="${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.590.0
	test? ( >=virtual/perl-Test-Simple-0.620.0 )
"

SRC_TEST="do parallel"
