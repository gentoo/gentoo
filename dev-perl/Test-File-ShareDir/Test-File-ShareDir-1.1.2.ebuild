# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
DIST_AUTHOR=KENTNL
DIST_VERSION=1.001002
inherit perl-module

DESCRIPTION="Create a Fake ShareDir for your modules for testing."
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sparc ~x86"
IUSE="test"

RDEPEND="virtual/perl-Carp
	dev-perl/Class-Tiny
	>=virtual/perl-Exporter-5.570.0
	dev-perl/File-Copy-Recursive
	>=dev-perl/File-ShareDir-1.0.0
	>=dev-perl/Path-Tiny-0.18.0
	dev-perl/Scope-Guard
	virtual/perl-parent"
DEPEND="virtual/perl-ExtUtils-MakeMaker
	${RDEPEND}
	test? (
		>=virtual/perl-CPAN-Meta-2.120.900
		virtual/perl-File-Spec
		dev-perl/Test-Fatal
		>=virtual/perl-Test-Simple-0.960.0
	)"
