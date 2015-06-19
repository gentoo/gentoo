# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Compress-Bzip2/Compress-Bzip2-2.220.0.ebuild,v 1.1 2015/05/01 20:02:13 dilfridge Exp $

EAPI=5

MODULE_VERSION=2.22
MODULE_AUTHOR=RURBAN
inherit perl-module

DESCRIPTION="Interface to Bzip2 compression library"

SLOT="0"
KEYWORDS="~amd64 ~ia64 ~mips ~sparc ~x86 ~ppc-aix"
IUSE="test"

RDEPEND="
	app-arch/bzip2
	virtual/perl-Carp
	virtual/perl-File-Spec
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? ( virtual/perl-Test-Simple )
"

SRC_TEST="do"
