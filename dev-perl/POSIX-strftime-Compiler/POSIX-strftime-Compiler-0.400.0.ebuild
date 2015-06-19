# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/POSIX-strftime-Compiler/POSIX-strftime-Compiler-0.400.0.ebuild,v 1.2 2015/06/13 19:24:55 dilfridge Exp $

EAPI=5

MODULE_AUTHOR=KAZEBURO
MODULE_VERSION=0.40

inherit perl-module

DESCRIPTION="GNU C library compatible strftime for loggers and servers"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

# POSIX -> perl
RDEPEND="
	virtual/perl-Carp
	virtual/perl-Exporter
	virtual/perl-Time-Local
"

# CPAN::Meta::Prereqs -> perl-CPAN-Meta
DEPEND="
	>=dev-perl/Module-Build-0.380.0
	virtual/perl-CPAN-Meta
	${RDEPEND}
	test? (
		>=virtual/perl-Test-Simple-0.980.0
	)
"

SRC_TEST="do parallel"
