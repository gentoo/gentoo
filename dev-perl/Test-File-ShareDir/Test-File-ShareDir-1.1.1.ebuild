# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Test-File-ShareDir/Test-File-ShareDir-1.1.1.ebuild,v 1.1 2015/05/28 07:45:06 monsieurp Exp $

EAPI=5
MODULE_AUTHOR=KENTNL
MODULE_VERSION=1.001001
inherit perl-module

DESCRIPTION="Create a Fake ShareDir for your modules for testing."
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="virtual/perl-Carp
	dev-perl/Class-Tiny
	>=virtual/perl-Exporter-5.570.0
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
SRC_TEST="do"
