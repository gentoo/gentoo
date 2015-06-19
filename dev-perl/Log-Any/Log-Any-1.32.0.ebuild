# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Log-Any/Log-Any-1.32.0.ebuild,v 1.1 2015/03/28 23:18:33 dilfridge Exp $

EAPI=5

MODULE_AUTHOR=DAGOLDEN
MODULE_VERSION=1.032
inherit perl-module

DESCRIPTION="Bringing loggers and listeners together"

SLOT="0"
KEYWORDS="~alpha ~amd64 ~ppc ~sparc ~x86"
IUSE="test"

RDEPEND="
	virtual/perl-Carp
	virtual/perl-Data-Dumper
	virtual/perl-Exporter
	virtual/perl-IO
"
DEPEND="${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.170.0
	test? (
		virtual/perl-Test-Simple
		virtual/perl-File-Spec
		virtual/perl-File-Temp
	)
"

SRC_TEST=do
