# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=ETHER
DIST_VERSION=0.24
inherit perl-module

DESCRIPTION="A working (require q{Class::Name}) and more"

SLOT="0"
KEYWORDS="alpha amd64 ~arm hppa ~ia64 ppc ppc64 sparc x86 ~ppc-aix ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~x86-solaris"
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
		dev-perl/Test-Needs
		>=virtual/perl-Test-Simple-0.880.0
		virtual/perl-version
	)
"
