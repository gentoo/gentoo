# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/RedisDB-Parser/RedisDB-Parser-2.200.0.ebuild,v 1.1 2014/11/30 00:19:56 dilfridge Exp $

EAPI=5

MODULE_AUTHOR=ZWON
MODULE_VERSION=2.20
inherit perl-module

DESCRIPTION="Redis protocol parser for RedisDB"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

SRC_TEST="do"

RDEPEND="
	virtual/perl-Encode
	dev-perl/Try-Tiny
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	virtual/perl-ExtUtils-CBuilder
	test? (
		dev-perl/Test-FailWarnings
		virtual/perl-Test-Simple
		dev-perl/Test-Most
	)
"
