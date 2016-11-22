# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MODULE_AUTHOR=RIBASUSHI
MODULE_VERSION=1.81
inherit perl-module

DESCRIPTION="Generate SQL from Perl data structures"

SLOT="0"
KEYWORDS="amd64 ~ppc x86 ~ppc-aix ~ppc-macos ~x86-solaris"
IUSE="test"

RDEPEND="
	>=virtual/perl-Exporter-5.570.0
	>=dev-perl/Hash-Merge-0.120.0
	virtual/perl-Scalar-List-Utils
	>=dev-perl/MRO-Compat-0.120.0
	>=dev-perl/Moo-1.4.2
	>=virtual/perl-Text-Balanced-2.0.0
"
DEPEND="${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.590.0
	test? (
		virtual/perl-Storable
		>=dev-perl/Test-Deep-0.101.0
		>=dev-perl/Test-Exception-0.310.0
		>=virtual/perl-Test-Simple-0.880.0
		dev-perl/Test-Warn
	)
"

SRC_TEST="do"
