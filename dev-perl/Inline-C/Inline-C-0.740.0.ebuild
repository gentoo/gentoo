# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Inline-C/Inline-C-0.740.0.ebuild,v 1.1 2015/02/25 23:16:31 dilfridge Exp $

EAPI=5

MODULE_AUTHOR=INGY
MODULE_VERSION=0.74
inherit perl-module

DESCRIPTION="C Language Support for Inline"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="
	>=virtual/perl-ExtUtils-MakeMaker-7
	>=virtual/perl-File-Spec-0.800.0
	>=dev-perl/Inline-0.790.0
	>=dev-perl/Parse-RecDescent-1.967.9
	>=dev-perl/Pegex-0.580.0
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	>=dev-perl/File-ShareDir-Install-0.60.0
	test? (
		dev-perl/File-Copy-Recursive
		dev-perl/IO-All
		>=virtual/perl-Test-Simple-0.880.0
		>=dev-perl/Test-Warn-0.230.0
		dev-perl/YAML-LibYAML
		virtual/perl-autodie
		>=virtual/perl-version-0.770.0
	)
"
