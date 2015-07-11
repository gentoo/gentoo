# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Net-IMAP-Simple/Net-IMAP-Simple-1.220.600.ebuild,v 1.1 2015/07/11 22:21:41 dilfridge Exp $

EAPI=5

MODULE_AUTHOR=JETTERO
MODULE_VERSION=1.2206
inherit perl-module

DESCRIPTION="Perl extension for simple IMAP account handling"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	dev-perl/Parse-RecDescent
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
"

SRC_TEST="do parallel"
