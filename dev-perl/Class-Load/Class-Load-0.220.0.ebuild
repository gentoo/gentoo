# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Class-Load/Class-Load-0.220.0.ebuild,v 1.5 2015/06/11 19:08:17 maekke Exp $

EAPI=5

MODULE_AUTHOR=ETHER
MODULE_VERSION=0.22
inherit perl-module

DESCRIPTION="A working (require q{Class::Name}) and more"

SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ppc ~ppc64 ~x86"
IUSE="test"

RDEPEND="
	virtual/perl-Carp
	dev-perl/Data-OptList
	virtual/perl-Exporter
	>=dev-perl/Module-Implementation-0.40.0
	>=dev-perl/Module-Runtime-0.12.0
	>=dev-perl/Package-Stash-0.140.0
	virtual/perl-Scalar-List-Utils
	dev-perl/Try-Tiny
	dev-perl/namespace-clean
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	>=dev-perl/Module-Build-Tiny-0.37.0
	test? (
		virtual/perl-File-Spec
		dev-perl/Test-Fatal
		virtual/perl-Test-Simple
		dev-perl/Test-Requires
	)
"

SRC_TEST="do"
