# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Test-Class/Test-Class-0.480.0.ebuild,v 1.2 2015/06/13 21:51:11 dilfridge Exp $

EAPI=5

MODULE_AUTHOR=ETHER
MODULE_VERSION=0.48
inherit perl-module

DESCRIPTION="Easily create test classes in an xUnit/JUnit style"

SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos"
IUSE="test"

RDEPEND="
	virtual/perl-Carp
	virtual/perl-File-Spec
	>=dev-perl/MRO-Compat-0.110.0
	dev-perl/Module-Runtime
	>=virtual/perl-Storable-2.40.0
	virtual/perl-Test-Simple
	dev-perl/Try-Tiny
"
DEPEND="${RDEPEND}
	>=dev-perl/Module-Build-0.400.400
	test? (
		virtual/perl-IO
		virtual/perl-Test-Simple
		>=dev-perl/Test-Exception-0.250.0
	)
"

SRC_TEST="do"
