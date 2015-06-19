# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Tie-Simple/Tie-Simple-1.03-r1.ebuild,v 1.1 2014/08/22 21:12:03 axs Exp $

EAPI=5

MODULE_AUTHOR=HANENKAMP
inherit perl-module

DESCRIPTION="Module for creating easier variable ties"

SLOT="0"
KEYWORDS="amd64 hppa x86"
IUSE=""

RDEPEND=""
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker"

SRC_TEST="do"
