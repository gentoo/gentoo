# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MODULE_AUTHOR=TIMB
MODULE_VERSION=1.634
inherit perl-module eutils

DESCRIPTION="Database independent interface for Perl"

SLOT="0"
KEYWORDS="alpha amd64 arm ~arm64 hppa ia64 ~mips ppc ppc64 ~s390 ~sh sparc x86 ~ppc-aix ~amd64-fbsd ~x86-fbsd ~x64-freebsd ~x86-freebsd ~x86-interix ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="test"

RDEPEND="
	>=dev-perl/PlRPC-0.200.0
	>=virtual/perl-Sys-Syslog-0.170.0
	virtual/perl-File-Spec
	!<=dev-perl/SQL-Statement-1.330.0
"
DEPEND="${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.480.0
	test? (
		>=virtual/perl-Test-Simple-0.900.0
	)
"

SRC_TEST="do parallel"

mydoc="ToDo"
MAKEOPTS="${MAKEOPTS} -j1"
