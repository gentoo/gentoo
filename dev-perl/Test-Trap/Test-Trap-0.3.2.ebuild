# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Test-Trap/Test-Trap-0.3.2.ebuild,v 1.3 2015/06/13 21:58:15 dilfridge Exp $

EAPI=5

MODULE_AUTHOR=EBHANSSEN
MODULE_VERSION=v${PV}

inherit perl-module

DESCRIPTION="Trap exit codes, exceptions, output, etc"

SLOT="0"
KEYWORDS=" ~amd64 ~arm ~x86 ~amd64-linux ~x86-linux"
IUSE="test"

# Carp??
RDEPEND="
	dev-perl/Data-Dump
	virtual/perl-Exporter
	virtual/perl-File-Temp
	virtual/perl-IO
"
DEPEND="${RDEPEND}
	>=dev-perl/Module-Build-0.400.3
	test? (
		|| ( >=virtual/perl-Test-Simple-1.1.10 >=dev-perl/Test-Tester-0.107 )
	)"

SRC_TEST="do parallel"
