# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MODULE_AUTHOR=ETHER
MODULE_VERSION=0.23
inherit perl-module

DESCRIPTION="A working (require q{Class::Name}) and more"

SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ppc ppc64 sparc x86"
IUSE="test"

# uses Scalar-Util
RDEPEND="
	virtual/perl-Carp
	dev-perl/Data-OptList
	virtual/perl-Exporter
	>=dev-perl/Module-Implementation-0.40.0
	>=dev-perl/Module-Runtime-0.12.0
	>=dev-perl/Package-Stash-0.140.0
	virtual/perl-Scalar-List-Utils
	dev-perl/Try-Tiny
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		virtual/perl-File-Spec
		dev-perl/Test-Fatal
		>=virtual/perl-Test-Simple-0.880.0
		dev-perl/Test-Requires
	)
"

SRC_TEST="do parallel"
