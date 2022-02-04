# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=ETHER
DIST_VERSION=1.014
inherit perl-module

DESCRIPTION="Author test that validates a package MANIFEST"

SLOT="0"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux"

RDEPEND="
	virtual/perl-ExtUtils-Manifest
	virtual/perl-File-Spec
	>=dev-perl/Module-Manifest-0.70.0
	virtual/perl-Test-Simple
"
BDEPEND="${RDEPEND}
	>=dev-perl/Module-Build-Tiny-0.39.0
	test? (
		virtual/perl-ExtUtils-MakeMaker
		virtual/perl-if
	)
"
