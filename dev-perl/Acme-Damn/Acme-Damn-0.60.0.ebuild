# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Acme-Damn/Acme-Damn-0.60.0.ebuild,v 1.1 2015/06/26 21:48:30 dilfridge Exp $

EAPI=5

MODULE_AUTHOR=IBB
MODULE_VERSION=0.06
inherit perl-module

DESCRIPTION="Module, that 'unblesses' Perl objects"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND=""
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		dev-perl/Test-Exception
		virtual/perl-Test-Simple
	)
"

PATCHES=( "${FILESDIR}/${PN}-respect-cflags.patch" )

SRC_TEST="do"
