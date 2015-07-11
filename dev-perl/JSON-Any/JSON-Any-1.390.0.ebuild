# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/JSON-Any/JSON-Any-1.390.0.ebuild,v 1.1 2015/07/11 20:01:30 dilfridge Exp $

EAPI=5

MODULE_AUTHOR=ETHER
MODULE_VERSION=1.39
inherit perl-module

DESCRIPTION="Wrapper Class for the various JSON classes (DEPRECATED)"

SLOT="0"
KEYWORDS="~amd64 ~x86 ~x64-macos ~x86-solaris"
IUSE="test"

RDEPEND="
	virtual/perl-Carp
	|| (
		>=dev-perl/JSON-XS-2.3
		virtual/perl-JSON-PP
		dev-perl/JSON
	)
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		virtual/perl-Data-Dumper
		virtual/perl-File-Spec
		virtual/perl-Storable
		dev-perl/Test-Fatal
		virtual/perl-Test-Simple
		dev-perl/Test-Requires
		>=dev-perl/Test-Warnings-0.9.0
		dev-perl/Test-Without-Module
	)
"

SRC_TEST="do parallel"
