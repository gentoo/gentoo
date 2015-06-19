# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Class-InsideOut/Class-InsideOut-1.130.0-r1.ebuild,v 1.1 2014/12/06 20:05:02 dilfridge Exp $

EAPI=5
MODULE_AUTHOR=DAGOLDEN
MODULE_VERSION=1.13
inherit perl-module

DESCRIPTION='A safe, simple inside-out object construction kit'
LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="
	virtual/perl-Carp
	dev-perl/Class-ISA
	virtual/perl-Exporter
	>=virtual/perl-Scalar-List-Utils-1.90.0
	virtual/perl-Storable
"
DEPEND="${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.300.0
	test? (
		virtual/perl-File-Spec
		virtual/perl-File-Temp
		virtual/perl-IO
		virtual/perl-Scalar-List-Utils
		>=virtual/perl-Test-Simple-0.45
		virtual/perl-XSLoader
		virtual/perl-threads
	)
"

SRC_TEST="do"
