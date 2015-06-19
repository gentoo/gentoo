# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/File-chmod/File-chmod-0.420.0.ebuild,v 1.1 2015/04/06 19:45:16 dilfridge Exp $

EAPI=5

MODULE_AUTHOR=XENO
MODULE_VERSION=0.42
inherit perl-module

DESCRIPTION="Implements symbolic and ls chmod modes"

SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~sparc ~x86 ~amd64-linux ~ia64-linux ~x86-linux ~x86-solaris"
IUSE="test"

RDEPEND="
	virtual/perl-Carp
	virtual/perl-Exporter
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		virtual/perl-File-Spec
		virtual/perl-File-Temp
		virtual/perl-IO
		virtual/perl-Test-Simple
		virtual/perl-autodie
	)
"

SRC_TEST=do
