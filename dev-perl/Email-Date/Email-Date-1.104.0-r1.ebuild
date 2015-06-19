# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Email-Date/Email-Date-1.104.0-r1.ebuild,v 1.1 2014/08/24 01:42:24 axs Exp $

EAPI=5

MODULE_AUTHOR=RJBS
MODULE_VERSION=1.104
inherit perl-module

DESCRIPTION="Find and Format Date Headers"

SLOT="0"
KEYWORDS="amd64 ppc ppc64 x86"
IUSE=""

RDEPEND=">=dev-perl/TimeDate-1.16
	>=dev-perl/Email-Abstract-2.13.1
	dev-perl/Email-Date-Format
	virtual/perl-Time-Local
	virtual/perl-Time-Piece"
DEPEND="${RDEPEND}"

SRC_TEST="do"
