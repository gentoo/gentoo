# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Schedule-Cron-Events/Schedule-Cron-Events-1.930.0.ebuild,v 1.1 2013/09/12 14:19:37 dev-zero Exp $

EAPI=5

MODULE_AUTHOR="KOHTS"
MODULE_VERSION="1.93"

inherit perl-module

DESCRIPTION="Take a line from a crontab and find out when events will occur"

SLOT="0"
KEYWORDS="~amd64"
IUSE="test"

RDEPEND="virtual/perl-Time-Local
	dev-perl/Set-Crontab"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? ( dev-perl/Test-Deep )"

SRC_TEST="do"
