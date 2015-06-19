# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/List-AllUtils/List-AllUtils-0.90.0.ebuild,v 1.17 2015/02/18 10:50:22 zlogene Exp $

EAPI=5

MODULE_AUTHOR=DROLSKY
MODULE_VERSION=0.08
inherit perl-module

DESCRIPTION='Combines List::Util and List::MoreUtils in one bite-sized package'

SLOT="0"
KEYWORDS="alpha amd64 arm ~arm64 hppa ia64 ~m68k ppc ppc64 ~s390 ~sh sparc x86 ~ppc-aix ~amd64-fbsd ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~x86-solaris"
IUSE="test"

RDEPEND=">=dev-perl/List-MoreUtils-0.280.0
	>=virtual/perl-Scalar-List-Utils-1.310.0"

DEPEND="${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.300.0
		test? (
	virtual/perl-File-Temp
	>=virtual/perl-Test-Simple-0.880.0
	dev-perl/Test-Warnings	)"

SRC_TEST="do"
