# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=ISHIGAKI
DIST_VERSION=0.9917
inherit perl-module

DESCRIPTION="Tool to scan your Perl code for its prerequisites"

SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-perl/Data-Dump
	>=virtual/perl-Exporter-5.570.0
	>=dev-perl/Module-CPANfile-1.100.400
	>=virtual/perl-Module-CoreList-3.110.0
	dev-perl/Module-Find
	dev-perl/Parse-Distname
	dev-perl/Regexp-Trie
	virtual/perl-parent
"
BDEPEND="
	${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	>=dev-perl/ExtUtils-MakeMaker-CPANfile-0.90.0
	test? (
		dev-perl/Test-FailWarnings
		>=virtual/perl-Test-Simple-0.980.0
		>=dev-perl/Test-UseAllModules-0.170.0
	)
"
